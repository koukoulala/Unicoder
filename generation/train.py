#!/usr/bin/env python3 -u
# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

from fairseq_cli.train import cli_main
import torch.multiprocessing
torch.multiprocessing.set_sharing_strategy('file_system')


if __name__ == '__main__':
    cli_main()
