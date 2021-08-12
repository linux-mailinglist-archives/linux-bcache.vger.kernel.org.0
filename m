Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DF83E9E0A
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Aug 2021 07:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbhHLFoT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 12 Aug 2021 01:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbhHLFoS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Aug 2021 01:44:18 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBE4C061765
        for <linux-bcache@vger.kernel.org>; Wed, 11 Aug 2021 22:43:52 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g12-20020a17090a7d0cb0290178f80de3d8so8818955pjl.2
        for <linux-bcache@vger.kernel.org>; Wed, 11 Aug 2021 22:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q0ci9iW+Tg6tr+Ee/1JnksS/vvDhs9ZzG86BxyzGZ+Q=;
        b=gmAHRh2OTjhp4JYpqE1sr7mYH6B7e2gl5y9BVXVgoAaJsYaljgblHJTpzYmn7vUwfD
         D2jxCF/oOLP61MfDS//u+rzitn3lcUb/4BsPynYMoQAHwrm3dNABDmWRLVnc6nN4ul/c
         fusvHjPhzq2USEqkL5Jj18QPK8tpOc1yDF9myR6H3SCqJ1soP2gJdoKYsZsGhL2Mc2o/
         VKPMX/4o074Z1Njxz8BXcanzpm++rM/y3ZufJ5Z5xKU3xx3gdy1L7TJTeNePcEmFjNN9
         4+PCCd+X8JLGvx8AANHeLTChuIPDli6wsA1V9vIyM4Xb3whm4jGjPmMzPY1waju/smnm
         j4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q0ci9iW+Tg6tr+Ee/1JnksS/vvDhs9ZzG86BxyzGZ+Q=;
        b=R0U3K6/gDl7RR+WXJmB6nRFoa5sd27FNDarTR/15qfPuyUXGTCPnsJkgmp8bFQANpv
         Uf9hSyPcP/nzzicBVYRenmYH0o1C8hJ7DUw6brfHYnXJP08nrUro+cFp5NcYMhi5AIUz
         lGNq0qpLpQIKOjinlDHjvPe179EI/nsE3ajBScijRIu6nLdPEsZ61udG2UPWqYFSKBBM
         Oa6MGiFoapMbMPEp3N/FUZZ8sQrbgUKaMt1uIR/W34ddKyseoqumHB87Bmq2o/011Sjr
         191ZagL2+aahrOGDZ1F3iN6v6GeVioGwU4u2hwq/j5iWJNMz4AY6c68JRP1Va2VvKCnl
         Gd6Q==
X-Gm-Message-State: AOAM532lhXIIjBVqxBpq7NB92pX4AjKkEA+pCCoIaGcjBPbgT/oCSg0q
        xGDNRLwAW4mpAqqL7c2UnxKLmPU7176C0Cs4sfUeMQ==
X-Google-Smtp-Source: ABdhPJyM2QDu351u6N5OdTLQwbkTWYZoxMNi2OuW1tbn5SQrybpoHUcPPyyekjChcCWkCKLja/XKw5yj1VS21KVUjPQ=
X-Received: by 2002:a17:902:ab91:b029:12b:8dae:b1ff with SMTP id
 f17-20020a170902ab91b029012b8daeb1ffmr2205012plr.52.1628747031799; Wed, 11
 Aug 2021 22:43:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210811170224.42837-1-colyli@suse.de> <20210811170224.42837-3-colyli@suse.de>
In-Reply-To: <20210811170224.42837-3-colyli@suse.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 11 Aug 2021 22:43:40 -0700
Message-ID: <CAPcyv4hhfg=mgN4AW8T2VWGVbKsQZkpPwpU5yVAVh2nFOxCBcg@mail.gmail.com>
Subject: Re: [PATCH v12 02/12] bcache: initialize the nvm pages allocator
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvdimm@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        "Huang, Ying" <ying.huang@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Aug 11, 2021 at 10:04 AM Coly Li <colyli@suse.de> wrote:
>
> From: Jianpeng Ma <jianpeng.ma@intel.com>
>
> This patch define the prototype data structures in memory and
> initializes the nvm pages allocator.
>
> The nvm address space which is managed by this allocator can consist of
> many nvm namespaces, and some namespaces can compose into one nvm set,
> like cache set. For this initial implementation, only one set can be
> supported.
>
> The users of this nvm pages allocator need to call register_namespace()
> to register the nvdimm device (like /dev/pmemX) into this allocator as
> the instance of struct nvm_namespace.
>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  drivers/md/bcache/Kconfig     |  10 +
>  drivers/md/bcache/Makefile    |   1 +
>  drivers/md/bcache/nvm-pages.c | 339 ++++++++++++++++++++++++++++++++++
>  drivers/md/bcache/nvm-pages.h |  96 ++++++++++
>  drivers/md/bcache/super.c     |   3 +
>  5 files changed, 449 insertions(+)
>  create mode 100644 drivers/md/bcache/nvm-pages.c
>  create mode 100644 drivers/md/bcache/nvm-pages.h
>
> diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
> index d1ca4d059c20..a69f6c0e0507 100644
> --- a/drivers/md/bcache/Kconfig
> +++ b/drivers/md/bcache/Kconfig
> @@ -35,3 +35,13 @@ config BCACHE_ASYNC_REGISTRATION
>         device path into this file will returns immediately and the real
>         registration work is handled in kernel work queue in asynchronous
>         way.
> +
> +config BCACHE_NVM_PAGES
> +       bool "NVDIMM support for bcache (EXPERIMENTAL)"
> +       depends on BCACHE
> +       depends on 64BIT
> +       depends on LIBNVDIMM
> +       depends on DAX
> +       help
> +         Allocate/release NV-memory pages for bcache and provide allocated pages
> +         for each requestor after system reboot.
> diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
> index 5b87e59676b8..2397bb7c7ffd 100644
> --- a/drivers/md/bcache/Makefile
> +++ b/drivers/md/bcache/Makefile
> @@ -5,3 +5,4 @@ obj-$(CONFIG_BCACHE)    += bcache.o
>  bcache-y               := alloc.o bset.o btree.o closure.o debug.o extents.o\
>         io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace.o\
>         util.o writeback.o features.o
> +bcache-$(CONFIG_BCACHE_NVM_PAGES) += nvm-pages.o
> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> new file mode 100644
> index 000000000000..6184c628d9cc
> --- /dev/null
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -0,0 +1,339 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Nvdimm page-buddy allocator
> + *
> + * Copyright (c) 2021, Intel Corporation.
> + * Copyright (c) 2021, Qiaowei Ren <qiaowei.ren@intel.com>.
> + * Copyright (c) 2021, Jianpeng Ma <jianpeng.ma@intel.com>.
> + */
> +
> +#include "bcache.h"
> +#include "nvm-pages.h"
> +
> +#include <linux/slab.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/dax.h>
> +#include <linux/pfn_t.h>
> +#include <linux/libnvdimm.h>
> +#include <linux/mm_types.h>
> +#include <linux/err.h>
> +#include <linux/pagemap.h>
> +#include <linux/bitmap.h>
> +#include <linux/blkdev.h>
> +
> +struct bch_nvmpg_set *global_nvmpg_set;
> +
> +void *bch_nvmpg_offset_to_ptr(unsigned long offset)
> +{
> +       int ns_id = BCH_NVMPG_GET_NS_ID(offset);
> +       struct bch_nvmpg_ns *ns = global_nvmpg_set->ns_tbl[ns_id];
> +
> +       if (offset == 0)
> +               return NULL;
> +
> +       ns_id = BCH_NVMPG_GET_NS_ID(offset);
> +       ns = global_nvmpg_set->ns_tbl[ns_id];
> +
> +       if (ns)
> +               return (void *)(ns->base_addr + BCH_NVMPG_GET_OFFSET(offset));
> +
> +       pr_err("Invalid ns_id %u\n", ns_id);
> +       return NULL;
> +}
> +
> +unsigned long bch_nvmpg_ptr_to_offset(struct bch_nvmpg_ns *ns, void *ptr)
> +{
> +       int ns_id = ns->ns_id;
> +       unsigned long offset = (unsigned long)(ptr - ns->base_addr);
> +
> +       return BCH_NVMPG_OFFSET(ns_id, offset);
> +}
> +
> +static void release_ns_tbl(struct bch_nvmpg_set *set)
> +{
> +       int i;
> +       struct bch_nvmpg_ns *ns;
> +
> +       for (i = 0; i < BCH_NVMPG_NS_MAX; i++) {
> +               ns = set->ns_tbl[i];
> +               if (ns) {
> +                       blkdev_put(ns->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXEC);
> +                       set->ns_tbl[i] = NULL;
> +                       set->attached_ns--;
> +                       kfree(ns);
> +               }
> +       }
> +
> +       if (set->attached_ns)
> +               pr_err("unexpected attached_ns: %u\n", set->attached_ns);
> +}
> +
> +static void release_nvmpg_set(struct bch_nvmpg_set *set)
> +{
> +       release_ns_tbl(set);
> +       kfree(set);
> +}
> +
> +/* Namespace 0 contains all meta data of the nvmpg allocation set */
> +static int init_nvmpg_set_header(struct bch_nvmpg_ns *ns)
> +{
> +       struct bch_nvmpg_set_header *set_header;
> +
> +       if (ns->ns_id != 0) {
> +               pr_err("unexpected ns_id %u for first nvmpg namespace.\n",
> +                      ns->ns_id);
> +               return -EINVAL;
> +       }
> +
> +       set_header = bch_nvmpg_offset_to_ptr(ns->sb->set_header_offset);
> +
> +       mutex_lock(&global_nvmpg_set->lock);
> +       global_nvmpg_set->set_header = set_header;
> +       global_nvmpg_set->heads_size = set_header->size;
> +       global_nvmpg_set->heads_used = set_header->used;
> +       mutex_unlock(&global_nvmpg_set->lock);
> +
> +       return 0;
> +}
> +
> +static int attach_nvmpg_set(struct bch_nvmpg_ns *ns)
> +{
> +       struct bch_nvmpg_sb *sb = ns->sb;
> +       int rc = 0;
> +
> +       mutex_lock(&global_nvmpg_set->lock);
> +
> +       if (global_nvmpg_set->ns_tbl[sb->this_ns]) {
> +               pr_err("ns_id %u already attached.\n", ns->ns_id);
> +               rc = -EEXIST;
> +               goto unlock;
> +       }
> +
> +       if (ns->ns_id != 0) {
> +               pr_err("unexpected ns_id %u for first namespace.\n", ns->ns_id);
> +               rc = -EINVAL;
> +               goto unlock;
> +       }
> +
> +       if (global_nvmpg_set->attached_ns > 0) {
> +               pr_err("multiple namespace attaching not supported yet\n");
> +               rc = -EOPNOTSUPP;
> +               goto unlock;
> +       }
> +
> +       if ((global_nvmpg_set->attached_ns + 1) > sb->total_ns) {
> +               pr_err("namespace counters error: attached %u > total %u\n",
> +                      global_nvmpg_set->attached_ns,
> +                      global_nvmpg_set->total_ns);
> +               rc = -EINVAL;
> +               goto unlock;
> +       }
> +
> +       memcpy(global_nvmpg_set->set_uuid, sb->set_uuid, 16);
> +       global_nvmpg_set->ns_tbl[sb->this_ns] = ns;
> +       global_nvmpg_set->attached_ns++;
> +       global_nvmpg_set->total_ns = sb->total_ns;
> +
> +unlock:
> +       mutex_unlock(&global_nvmpg_set->lock);
> +       return rc;
> +}
> +
> +static int read_nvdimm_meta_super(struct block_device *bdev,
> +                                 struct bch_nvmpg_ns *ns)
> +{
> +       struct page *page;
> +       struct bch_nvmpg_sb *sb;
> +       uint64_t expected_csum = 0;
> +       int r;
> +
> +       page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
> +                               BCH_NVMPG_SB_OFFSET >> PAGE_SHIFT, GFP_KERNEL);
> +
> +       if (IS_ERR(page))
> +               return -EIO;
> +
> +       sb = (struct bch_nvmpg_sb *)
> +            (page_address(page) + offset_in_page(BCH_NVMPG_SB_OFFSET));
> +
> +       r = -EINVAL;
> +       expected_csum = csum_set(sb);
> +       if (expected_csum != sb->csum) {
> +               pr_info("csum is not match with expected one\n");
> +               goto put_page;
> +       }
> +
> +       if (memcmp(sb->magic, bch_nvmpg_magic, 16)) {
> +               pr_info("invalid bch_nvmpg_magic\n");
> +               goto put_page;
> +       }
> +
> +       if (sb->sb_offset !=
> +           BCH_NVMPG_OFFSET(sb->this_ns, BCH_NVMPG_SB_OFFSET)) {
> +               pr_info("invalid superblock offset 0x%llx\n", sb->sb_offset);
> +               goto put_page;
> +       }
> +
> +       r = -EOPNOTSUPP;
> +       if (sb->total_ns != 1) {
> +               pr_info("multiple name space not supported yet.\n");
> +               goto put_page;
> +       }
> +
> +
> +       r = 0;
> +       /* Necessary for DAX mapping */
> +       ns->page_size = sb->page_size;
> +       ns->pages_total = sb->pages_total;
> +
> +put_page:
> +       put_page(page);
> +       return r;
> +}
> +
> +struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
> +{
> +       struct bch_nvmpg_ns *ns = NULL;
> +       struct bch_nvmpg_sb *sb = NULL;
> +       char buf[BDEVNAME_SIZE];
> +       struct block_device *bdev;
> +       pgoff_t pgoff;
> +       int id, err;
> +       char *path;
> +       long dax_ret = 0;
> +
> +       path = kstrndup(dev_path, 512, GFP_KERNEL);
> +       if (!path) {
> +               pr_err("kstrndup failed\n");
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       bdev = blkdev_get_by_path(strim(path),
> +                                 FMODE_READ|FMODE_WRITE|FMODE_EXEC,
> +                                 global_nvmpg_set);
> +       if (IS_ERR(bdev)) {
> +               pr_err("get %s error: %ld\n", dev_path, PTR_ERR(bdev));
> +               kfree(path);
> +               return ERR_PTR(PTR_ERR(bdev));
> +       }
> +
> +       err = -ENOMEM;
> +       ns = kzalloc(sizeof(struct bch_nvmpg_ns), GFP_KERNEL);
> +       if (!ns)
> +               goto bdput;
> +
> +       err = -EIO;
> +       if (read_nvdimm_meta_super(bdev, ns)) {
> +               pr_err("%s read nvdimm meta super block failed.\n",
> +                      bdevname(bdev, buf));
> +               goto free_ns;
> +       }
> +
> +       err = -EOPNOTSUPP;
> +       if (!bdev_dax_supported(bdev, ns->page_size)) {
> +               pr_err("%s don't support DAX\n", bdevname(bdev, buf));
> +               goto free_ns;
> +       }
> +
> +       err = -EINVAL;
> +       if (bdev_dax_pgoff(bdev, 0, ns->page_size, &pgoff)) {
> +               pr_err("invalid offset of %s\n", bdevname(bdev, buf));
> +               goto free_ns;
> +       }
> +
> +       err = -ENOMEM;
> +       ns->dax_dev = fs_dax_get_by_bdev(bdev);
> +       if (!ns->dax_dev) {
> +               pr_err("can't by dax device by %s\n", bdevname(bdev, buf));
> +               goto free_ns;
> +       }
> +
> +       err = -EINVAL;
> +       id = dax_read_lock();
> +       dax_ret = dax_direct_access(ns->dax_dev, pgoff, ns->pages_total,
> +                                   &ns->base_addr, &ns->start_pfn);
> +       if (dax_ret <= 0) {
> +               pr_err("dax_direct_access error\n");
> +               dax_read_unlock(id);
> +               goto free_ns;
> +       }
> +
> +       if (dax_ret < ns->pages_total) {
> +               pr_warn("mapped range %ld is less than ns->pages_total %lu\n",
> +                       dax_ret, ns->pages_total);

This failure will become a common occurrence with CXL namespaces that
will have discontiguous range support. It's already the case for
dax-devices for soft-reserved memory [1]. In the CXL case the
discontinuity will be 256MB aligned, for the soft-reserved dax-devices
the discontinuity granularity can be as small as 4K.

[1]: https://elixir.bootlin.com/linux/v5.14-rc5/source/drivers/dax/device.c#L414
