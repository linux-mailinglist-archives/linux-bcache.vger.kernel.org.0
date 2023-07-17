Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38DF755B0B
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jul 2023 07:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjGQF7O (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Jul 2023 01:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjGQF7N (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Jul 2023 01:59:13 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A305FE64
        for <linux-bcache@vger.kernel.org>; Sun, 16 Jul 2023 22:59:10 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-316feb137a7so941813f8f.1
        for <linux-bcache@vger.kernel.org>; Sun, 16 Jul 2023 22:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689573549; x=1692165549;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XpZ7hzVo6aNRf/h0hvR1mJB9+o96DCCB7QWW+ufx0pU=;
        b=gsqGpIKM9mPZMzA3LvCcDIfoN8H/I4Adtj3sPVDR0Qugu4fhofW09QVzj5xI2qbeli
         7z55hpCnuiekEYgeca3V5kND/jzJWvFjnYqtczmny22VjIqTff/DsFaO8dNjDi+x7gUu
         oMz3GifjMJ/pZrCiO8dYBWgAs2gG084ucLef+mUtQoBlo/zRBH28cQ1puIgmpdw1BQqr
         KzmJaU9HF9GGC43sUviMKUAwFx+jX6qEGK9expFsrA7U7V8OYuusZ9hICQZomrtlFkGk
         yuJdWwv1K+0nnSE4dgrpe49yImRCpvM9TIZdqcoZ+6LivSzUV0kwEP/dztk9zHYiUDeT
         mt9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689573549; x=1692165549;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XpZ7hzVo6aNRf/h0hvR1mJB9+o96DCCB7QWW+ufx0pU=;
        b=DOxO43eKb+YBTV7qdkJn3Pg5OTaNSkyQRnrqNtkZ8SJ418cxatAXmVu21sargzYlDe
         FEidgGNqpMpZplsI0uN4ntMI6wrBE7RmhBnRdJAi1aLqrauQFBkA1fmkZ3E5mishNigC
         3O+VhjDOEWu/fjpD9VVS3ze1B1/51Wtnzb7aPA7Be8XKlamDyUpEAXN2c6BYfJ9a8n7A
         IOn8WQ2qjnwLC+ollrlUXVSW5yS1MC1Anmo9VQ9F/Bh+2VF0d0BMfpT9a/4ZB4p6ZMTk
         9v3N/KrFbhhKawhDkSatYp8awdBD13nAXgRTzIog8ga+9mdl2Q1ARP7a2Zg8+MEfdMD+
         YMhQ==
X-Gm-Message-State: ABy/qLY87w7MvnEXrJKzc4oS3J4S7rNi8YbH6uewtfLaEjHxjftqt05H
        MB/KafM0tzUms5I0mP+wpPztSA==
X-Google-Smtp-Source: APBJJlFAOsPnYfrYraYLXRFFOsywGCy5jChWoIeEJmfmfkbwoichwi2xYwRd3KwR3od1Luku3gg3ng==
X-Received: by 2002:a05:6000:18cf:b0:315:a32d:311f with SMTP id w15-20020a05600018cf00b00315a32d311fmr9388489wrq.14.1689573548858;
        Sun, 16 Jul 2023 22:59:08 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id h7-20020a5d5487000000b0030ae901bc54sm18071409wrv.62.2023.07.16.22.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jul 2023 22:59:06 -0700 (PDT)
Date:   Mon, 17 Jul 2023 08:59:03 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     oe-kbuild@lists.linux.dev, Mingzhe Zou <mingzhe.zou@easystack.cn>,
        colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        bcache@lists.ewheeler.net, zoumingzhe@qq.com
Subject: Re: [PATCH v3] bcache: Separate bch_moving_gc() from bch_btree_gc()
Message-ID: <83e846fd-a4e5-4b89-8a22-ec4189335379@kadam.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230629114740.311-1-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Mingzhe,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mingzhe-Zou/bcache-Separate-bch_moving_gc-from-bch_btree_gc/20230629-194834
base:   linus/master
patch link:    https://lore.kernel.org/r/20230629114740.311-1-mingzhe.zou%40easystack.cn
patch subject: [PATCH v3] bcache: Separate bch_moving_gc() from bch_btree_gc()
config: x86_64-randconfig-m001-20230710 (https://download.01.org/0day-ci/archive/20230716/202307160359.0vHG3r40-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230716/202307160359.0vHG3r40-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202307160359.0vHG3r40-lkp@intel.com/

New smatch warnings:
drivers/md/bcache/btree.c:1887 moving_gc_should_run() error: uninitialized symbol 'used_sectors'.

Old smatch warnings:
drivers/md/bcache/btree.c:1535 btree_gc_rewrite_node() error: 'n' dereferencing possible ERR_PTR()
drivers/md/bcache/btree.c:1551 btree_gc_rewrite_node() error: 'n' dereferencing possible ERR_PTR()

vim +/used_sectors +1887 drivers/md/bcache/btree.c

4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1856  static bool moving_gc_should_run(struct cache_set *c)
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1857  {
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1858  	struct bucket *b;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1859  	struct cache *ca = c->cache;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1860  	size_t moving_gc_threshold = ca->sb.bucket_size >> 2, frag_percent;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1861  	unsigned long used_buckets = 0, frag_buckets = 0, move_buckets = 0;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1862  	unsigned long dirty_sectors = 0, frag_sectors, used_sectors;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1863  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1864  	if (c->gc_stats.in_use > bch_cutoff_writeback_sync)
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1865  		return true;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1866  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1867  	mutex_lock(&c->bucket_lock);
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1868  	for_each_bucket(b, ca) {
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1869  		if (GC_MARK(b) != GC_MARK_DIRTY)
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1870  			continue;

Smatch is complaining that we might not enter the loop or there could be
no GC_MARK_DIRTY entries.

4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1871  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1872  		used_buckets++;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1873  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1874  		used_sectors = GC_SECTORS_USED(b);
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1875  		dirty_sectors += used_sectors;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1876  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1877  		if (used_sectors < ca->sb.bucket_size)
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1878  			frag_buckets++;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1879  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1880  		if (used_sectors <= moving_gc_threshold)
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1881  			move_buckets++;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1882  	}
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1883  	mutex_unlock(&c->bucket_lock);
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1884  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1885  	c->fragment_nbuckets = frag_buckets;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1886  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29 @1887  	if (used_sectors < c->nbuckets * bch_cutoff_writeback / 100)

It's sort of weird that we are using the used_sectors value from the
last MARK_DIRTY iteration through the loop.  Should it be used_buckets?

4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1888  		return false;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1889  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1890  	if (move_buckets > ca->heap.size)
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1891  		return true;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1892  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1893  	frag_sectors = used_buckets * ca->sb.bucket_size - dirty_sectors;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1894  	frag_percent = div_u64(frag_sectors * 100, ca->sb.bucket_size * c->nbuckets);
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1895  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1896  	if (frag_percent >= COPY_GC_PERCENT)
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1897  		return true;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1898  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1899  	if (used_sectors > c->nbuckets * bch_cutoff_writeback_sync / 100)
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1900  		return true;
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1901  
4b0cf76f1e36e7 Mingzhe Zou     2023-06-29  1902  	return false;
cafe563591446c Kent Overstreet 2013-03-23  1903  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

