#!/bin/bash
cd DLpatch/
tar cf - linux-3.18.29 | pixz > linux-3.18.29.tar.xz
mkdir ../dl 2>/dev/null
mv linux-3.18.29.tar.xz ../dl/
cd ..