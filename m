Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6926BA5DE
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Mar 2023 05:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjCOEDK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Mar 2023 00:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCOEDI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Mar 2023 00:03:08 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB3D46A0
        for <linux-bcache@vger.kernel.org>; Tue, 14 Mar 2023 21:03:07 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so253940wmb.5
        for <linux-bcache@vger.kernel.org>; Tue, 14 Mar 2023 21:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678852985;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LKipZg32j4aSYL/ldQSJVuc/wPyuqxco8uSwoElc/X8=;
        b=Zf81Oo+oWlBnof984tD+2xXftdUSEI6tRb13AeHtCVEPCFLxbywgsxT2VOSx90hj69
         wbU4X0LpP+1x4lewxwCtAcnfchfKN+HcyaHAwje3YyMYi3UKNxsvkpJ6T3rrNha7CYu7
         xNcw9bYfPSFx4OjwZxewMbmB2LJuaCBCeMzW+vHzjqt9olDKLk7Au9cU/+Bm/hNVv7hs
         fMIJcjz9L+6JEw3F8umgAA/luX+G6CIX1vVRqjT5l+TlxrSfsop8D6nY1Kreqh386oyt
         OIgxAc9WQWa90VD9fm7g+fJJ+iAoYR8y9K5zVBYQtMfgfAwE54qt9qN/v1917uQ6K3zg
         prDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678852985;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LKipZg32j4aSYL/ldQSJVuc/wPyuqxco8uSwoElc/X8=;
        b=5EOiwh5cLTRzwdwA8OxfIQyn9mXu93raUAvCnEena5jRGPZ/AUwys/c8Wk9CNkPB3g
         ilNsoCgzlfxR1aQ3SL/buhUB5j5QIkSVyBQkug0iWHZqFrYlnltuZ1xerUMfPqzc52jk
         R+GLmaEKmDnKIiU2zwz40/766i4PVSCebWG8zyfPj1TkU8nz0xWaKaO1YEoW5w0mA+k4
         ZlQpm00UR6wKO6tYOe5sZXDvb8EsZ/qJtUuGTxP2QrBjdF9J6gEykli8YdmdRpZnPvBZ
         uUc4uGKy1QIyGQCViae5gBNaxJzhK4uo8w+hOCHJ8fWGA14BY5lImcLCMAF7mBMhka6A
         qWDg==
X-Gm-Message-State: AO0yUKUtrKl+L6Xzqg0d3Al3vIEfXKUgUecx+Z5551AxyNJAJZhN6y21
        jejfUiNM8WZ23rfA3ggBUcEmV3+5axo=
X-Google-Smtp-Source: AK7set9+zU5NflcbfyDYbrOnB7l6MiUXZzaFVy5MWupsPgtQa4A2GoEu/V38pEZLCOuveMJkd+7oIA==
X-Received: by 2002:a05:600c:19c7:b0:3ed:2b49:1571 with SMTP id u7-20020a05600c19c700b003ed2b491571mr4683283wmq.20.1678852985252;
        Tue, 14 Mar 2023 21:03:05 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id k6-20020a05600c1c8600b003e209b45f6bsm467905wms.29.2023.03.14.21.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 21:03:04 -0700 (PDT)
Date:   Wed, 15 Mar 2023 07:03:00 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     oe-kbuild@lists.linux.dev, mingzhe.zou@easystack.cn,
        colyli@suse.de, andrea.tomassetti-opensource@devo.com,
        bcache@lists.ewheeler.net
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        zoumingzhe@qq.com, Dongsheng Yang <dongsheng.yang@easystack.cn>,
        mingzhe <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH v2 3/3] bcache: support overlay bcache
Message-ID: <ecf6a168-dd9c-4a11-a872-088030ef47a5@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202030221.14397-3-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/mingzhe-zou-easystack-cn/bcache-submit-writeback-inflight-dirty-writes-in-batch/20230202-110624
patch link:    https://lore.kernel.org/r/20230202030221.14397-3-mingzhe.zou%40easystack.cn
patch subject: [PATCH v2 3/3] bcache: support overlay bcache
config: ia64-randconfig-m031-20230312 (https://download.01.org/0day-ci/archive/20230315/202303150200.4UK2OWti-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Link: https://lore.kernel.org/r/202303150200.4UK2OWti-lkp@intel.com/

smatch warnings:
drivers/md/bcache/super.c:1573 flash_dev_run() warn: missing error code 'err'

vim +/err +1573 drivers/md/bcache/super.c

cafe563591446c Kent Overstreet   2013-03-23  1540  static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
cafe563591446c Kent Overstreet   2013-03-23  1541  {
bbce89267a538f Dongsheng Yang    2023-02-02  1542  	int ret;
2961c3bbcaec0e Luis Chamberlain  2021-10-15  1543  	int err = -ENOMEM;
cafe563591446c Kent Overstreet   2013-03-23  1544  	struct bcache_device *d = kzalloc(sizeof(struct bcache_device),
cafe563591446c Kent Overstreet   2013-03-23  1545  					  GFP_KERNEL);
cafe563591446c Kent Overstreet   2013-03-23  1546  	if (!d)
2961c3bbcaec0e Luis Chamberlain  2021-10-15  1547  		goto err_ret;
cafe563591446c Kent Overstreet   2013-03-23  1548  
cafe563591446c Kent Overstreet   2013-03-23  1549  	closure_init(&d->cl, NULL);
cafe563591446c Kent Overstreet   2013-03-23  1550  	set_closure_fn(&d->cl, flash_dev_flush, system_wq);
cafe563591446c Kent Overstreet   2013-03-23  1551  
cafe563591446c Kent Overstreet   2013-03-23  1552  	kobject_init(&d->kobj, &bch_flash_dev_ktype);
cafe563591446c Kent Overstreet   2013-03-23  1553  
4e1ebae3ee4e0c Coly Li           2020-10-01  1554  	if (bcache_device_init(d, block_bytes(c->cache), u->sectors,
c62b37d96b6eb3 Christoph Hellwig 2020-07-01  1555  			NULL, &bcache_flash_ops))
cafe563591446c Kent Overstreet   2013-03-23  1556  		goto err;
cafe563591446c Kent Overstreet   2013-03-23  1557  
cafe563591446c Kent Overstreet   2013-03-23  1558  	bcache_device_attach(d, c, u - c->uuids);
175206cf9ab631 Tang Junhui       2017-09-07  1559  	bch_sectors_dirty_init(d);
cafe563591446c Kent Overstreet   2013-03-23  1560  	bch_flash_dev_request_init(d);
2961c3bbcaec0e Luis Chamberlain  2021-10-15  1561  	err = add_disk(d->disk);
2961c3bbcaec0e Luis Chamberlain  2021-10-15  1562  	if (err)
2961c3bbcaec0e Luis Chamberlain  2021-10-15  1563  		goto err;
cafe563591446c Kent Overstreet   2013-03-23  1564  
bbce89267a538f Dongsheng Yang    2023-02-02  1565  	err = kobject_add(&d->kobj, &disk_to_dev(d->disk)->kobj, "bcache_fdev");
2961c3bbcaec0e Luis Chamberlain  2021-10-15  1566  	if (err)
cafe563591446c Kent Overstreet   2013-03-23  1567  		goto err;
cafe563591446c Kent Overstreet   2013-03-23  1568  
bbce89267a538f Dongsheng Yang    2023-02-02  1569  	ret = sysfs_create_link_nowarn(&disk_to_dev(d->disk)->kobj,
bbce89267a538f Dongsheng Yang    2023-02-02  1570  				       &d->kobj, "bcache");
bbce89267a538f Dongsheng Yang    2023-02-02  1571  	if (ret && ret != -EEXIST) {
bbce89267a538f Dongsheng Yang    2023-02-02  1572  		pr_err("Couldn't create lagacy flash dev ->bcache");
bbce89267a538f Dongsheng Yang    2023-02-02 @1573  		goto err;

Get rid of the "ret" variable and use "err" instead.

bbce89267a538f Dongsheng Yang    2023-02-02  1574  	}
bbce89267a538f Dongsheng Yang    2023-02-02  1575  
cafe563591446c Kent Overstreet   2013-03-23  1576  	bcache_device_link(d, c, "volume");
cafe563591446c Kent Overstreet   2013-03-23  1577  
5342fd4255021e Coly Li           2021-01-04  1578  	if (bch_has_feature_obso_large_bucket(&c->cache->sb)) {
5342fd4255021e Coly Li           2021-01-04  1579  		pr_err("The obsoleted large bucket layout is unsupported, set the bcache device into read-only\n");
5342fd4255021e Coly Li           2021-01-04  1580  		pr_err("Please update to the latest bcache-tools to create the cache device\n");
5342fd4255021e Coly Li           2021-01-04  1581  		set_disk_ro(d->disk, 1);
5342fd4255021e Coly Li           2021-01-04  1582  	}
5342fd4255021e Coly Li           2021-01-04  1583  
cafe563591446c Kent Overstreet   2013-03-23  1584  	return 0;
cafe563591446c Kent Overstreet   2013-03-23  1585  err:
cafe563591446c Kent Overstreet   2013-03-23  1586  	kobject_put(&d->kobj);
2961c3bbcaec0e Luis Chamberlain  2021-10-15  1587  err_ret:
2961c3bbcaec0e Luis Chamberlain  2021-10-15  1588  	return err;
cafe563591446c Kent Overstreet   2013-03-23  1589  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

