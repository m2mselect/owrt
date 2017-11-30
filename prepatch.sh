#!/bin/bash
cd DLpatch/
tar cfJ linux-3.18.29.tar.xz linux-3.18.29
mkdir ../dl 2>/dev/null
mv linux-3.18.29.tar.xz ../dl/
cd ..