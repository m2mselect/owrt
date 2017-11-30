/*
 * Freescale MXS power subsystem
 *
 * Copyright (C) 2014 Stefan Wahren
 *
 * Inspired by imx-bootlets
 */

/*
 * The code contained herein is licensed under the GNU General Public
 * License. You may obtain a copy of the GNU General Public License
 * Version 2 or later at the following locations:
 *
 * http://www.opensource.org/licenses/gpl-license.html
 * http://www.gnu.org/copyleft/gpl.html
 */

#include <linux/device.h>
#include <linux/err.h>
#include <linux/io.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/of_platform.h>
#include <linux/platform_device.h>
#include <linux/power_supply.h>
#include <linux/stmp_device.h>
#include <linux/types.h>

#define BM_POWER_CTRL_POLARITY_VBUSVALID	BIT(5)
#define BM_POWER_CTRL_VBUSVALID_IRQ		BIT(4)
#define BM_POWER_CTRL_ENIRQ_VBUS_VALID		BIT(3)

#define HW_POWER_5VCTRL_OFFSET	0x10

#define BM_POWER_5VCTRL_VBUSVALID_THRESH	(7 << 8)
#define BM_POWER_5VCTRL_PWDN_5VBRNOUT		BIT(7)
#define BM_POWER_5VCTRL_ENABLE_LINREG_ILIMIT	BIT(6)
#define BM_POWER_5VCTRL_VBUSVALID_5VDETECT	BIT(4)

#define HW_POWER_5VCTRL_VBUSVALID_THRESH_4_40V	(5 << 8)

struct mxs_power_data {
	void __iomem *base_addr;
	struct power_supply ac;
};

static enum power_supply_property mxs_power_ac_props[] = {
	POWER_SUPPLY_PROP_ONLINE,
};

static int mxs_power_ac_get_property(struct power_supply *psy,
				     enum power_supply_property psp,
				     union power_supply_propval *val)
{
	int ret = 0;

	switch (psp) {
	case POWER_SUPPLY_PROP_ONLINE:
		val->intval = 1;
		break;
	default:
		ret = -EINVAL;
		break;
	}
	return ret;
}

static const struct of_device_id of_mxs_power_match[] = {
	{ .compatible = "fsl,imx23-power" },
	{ .compatible = "fsl,imx28-power" },
	{ /* end */ }
};
MODULE_DEVICE_TABLE(of, of_mxs_power_match);

static int mxs_power_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	struct device_node *np = dev->of_node;
	struct resource *res;
	struct mxs_power_data *data;
	void __iomem *v5ctrl_addr;
	int ret;

	if (!np) {
		dev_err(dev, "missing device tree\n");
		return -EINVAL;
	}

	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
	if (!data)
		return -ENOMEM;

	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	data->base_addr = devm_ioremap_resource(dev, res);
	if (IS_ERR(data->base_addr))
		return PTR_ERR(data->base_addr);

	platform_set_drvdata(pdev, data);
	data->ac.name = "ac";
	data->ac.type = POWER_SUPPLY_TYPE_MAINS;
	data->ac.properties = mxs_power_ac_props;
	data->ac.num_properties = ARRAY_SIZE(mxs_power_ac_props);
	data->ac.get_property = mxs_power_ac_get_property;

	ret = power_supply_register(&pdev->dev, &data->ac);
	if (ret)
	{
		//devm_kfree(data);
		return ret;
	}

	v5ctrl_addr = data->base_addr + HW_POWER_5VCTRL_OFFSET;

	/* Make sure the current limit of the linregs are disabled. */
	writel(BM_POWER_5VCTRL_ENABLE_LINREG_ILIMIT,
	       v5ctrl_addr + STMP_OFFSET_REG_CLR);

	dev_info(dev, "initialized\n");
	
	return of_platform_populate(np, NULL, NULL, dev);
}

static struct platform_driver mxs_power_driver = {
	.driver = {
		.name	= "mxs-power",
		.of_match_table = of_mxs_power_match,
	},
	.probe	= mxs_power_probe,
};

module_platform_driver(mxs_power_driver);

MODULE_AUTHOR("Stefan Wahren <stefan.wahren@i2se.com>");
MODULE_DESCRIPTION("Freescale MXS power subsystem");
MODULE_LICENSE("GPL v2");
