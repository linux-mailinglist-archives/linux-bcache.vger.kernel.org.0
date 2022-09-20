Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1BE5BEF12
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Sep 2022 23:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiITVVB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Sep 2022 17:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiITVVB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Sep 2022 17:21:01 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2525572879
        for <linux-bcache@vger.kernel.org>; Tue, 20 Sep 2022 14:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663708860; x=1695244860;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lSdIUMi85a1lOCpYDsGNMFwY8mwWz3aZs5jakpKg5Ss=;
  b=nJ/7Acyh8oB9J+gyQMNNE4LkWRywj9NR+qKOK5WOZDCdoSy1AQ7McVd2
   c2PavCwMakaG8O4LYQprJD2zX32ax+UZAqTdfSN5bigoc37dGS2gdlzB1
   ic5l2uyTHUjWtaaYZ9Pele1FIYVG3qXOhzZnC8A4siW4qyJ0/qhotHVGb
   RWmpCMgzYpU/WM5G+Y2ty26RdY9pjWavv3Kn7TU7GPiU9wEu/w1V24Kpc
   cwsMuBOlf8CVwPps3Pjcw9koIVnhKxUS5idq+/gD0+iLL1f802MsYQROx
   u+ZObMiP5TxnlxuMeqG5A/eQB1i55/dPVbB4llU3mpxIfb9GnQ9XWWbds
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="386108341"
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="386108341"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 14:20:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="570249641"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 20 Sep 2022 14:20:55 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oakfn-0002yj-0d;
        Tue, 20 Sep 2022 21:20:55 +0000
Date:   Wed, 21 Sep 2022 05:20:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     mingzhe.zou@easystack.cn, colyli@suse.de,
        linux-bcache@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, zoumingzhe@qq.com
Subject: Re: [PATCH v3 1/3] bcache: bch_sectors_dirty_init() check each
 thread result and return error
Message-ID: <202209210545.PcfwfXrP-lkp@intel.com>
References: <20220920112850.13157-1-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920112850.13157-1-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.0-rc6 next-20220920]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/mingzhe-zou-easystack-cn/bcache-bch_sectors_dirty_init-check-each-thread-result-and-return-error/20220920-193043
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 521a547ced6477c54b4b0cc206000406c221b4d6
config: hexagon-randconfig-r041-20220921 (https://download.01.org/0day-ci/archive/20220921/202209210545.PcfwfXrP-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 791a7ae1ba3efd6bca96338e10ffde557ba83920)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1e312ee12bfc74c18aa6bc0c1519b36f22d8db13
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review mingzhe-zou-easystack-cn/bcache-bch_sectors_dirty_init-check-each-thread-result-and-return-error/20220920-193043
        git checkout 1e312ee12bfc74c18aa6bc0c1519b36f22d8db13
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/md/bcache/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/md/bcache/writeback.c:940:6: error: conflicting types for 'bch_sectors_dirty_init'
   void bch_sectors_dirty_init(struct bcache_device *d)
        ^
   drivers/md/bcache/writeback.h:152:5: note: previous declaration is here
   int bch_sectors_dirty_init(struct bcache_device *d);
       ^
>> drivers/md/bcache/writeback.c:962:3: error: void function 'bch_sectors_dirty_init' should not return a value [-Wreturn-type]
                   return 0;
                   ^      ~
   drivers/md/bcache/writeback.c:1011:2: error: void function 'bch_sectors_dirty_init' should not return a value [-Wreturn-type]
           return ret;
           ^      ~~~
   3 errors generated.


vim +/bch_sectors_dirty_init +940 drivers/md/bcache/writeback.c

b144e45fc57649 Coly Li         2020-03-22   939  
b144e45fc57649 Coly Li         2020-03-22  @940  void bch_sectors_dirty_init(struct bcache_device *d)
b144e45fc57649 Coly Li         2020-03-22   941  {
b144e45fc57649 Coly Li         2020-03-22   942  	int i;
1e312ee12bfc74 ZouMingzhe      2022-09-20   943  	int ret = 0;
b144e45fc57649 Coly Li         2020-03-22   944  	struct bkey *k = NULL;
b144e45fc57649 Coly Li         2020-03-22   945  	struct btree_iter iter;
b144e45fc57649 Coly Li         2020-03-22   946  	struct sectors_dirty_init op;
b144e45fc57649 Coly Li         2020-03-22   947  	struct cache_set *c = d->c;
4dc34ae1b45fe2 Coly Li         2022-05-24   948  	struct bch_dirty_init_state state;
b144e45fc57649 Coly Li         2020-03-22   949  
b144e45fc57649 Coly Li         2020-03-22   950  	/* Just count root keys if no leaf node */
4dc34ae1b45fe2 Coly Li         2022-05-24   951  	rw_lock(0, c->root, c->root->level);
b144e45fc57649 Coly Li         2020-03-22   952  	if (c->root->level == 0) {
b144e45fc57649 Coly Li         2020-03-22   953  		bch_btree_op_init(&op.op, -1);
b144e45fc57649 Coly Li         2020-03-22   954  		op.inode = d->id;
b144e45fc57649 Coly Li         2020-03-22   955  		op.count = 0;
b144e45fc57649 Coly Li         2020-03-22   956  
b144e45fc57649 Coly Li         2020-03-22   957  		for_each_key_filter(&c->root->keys,
b144e45fc57649 Coly Li         2020-03-22   958  				    k, &iter, bch_ptr_invalid)
b144e45fc57649 Coly Li         2020-03-22   959  			sectors_dirty_init_fn(&op.op, c->root, k);
80db4e4707e78c Coly Li         2022-05-24   960  
4dc34ae1b45fe2 Coly Li         2022-05-24   961  		rw_unlock(0, c->root);
1e312ee12bfc74 ZouMingzhe      2022-09-20  @962  		return 0;
b144e45fc57649 Coly Li         2020-03-22   963  	}
b144e45fc57649 Coly Li         2020-03-22   964  
7d6b902ea0e02b Coly Li         2022-05-27   965  	memset(&state, 0, sizeof(struct bch_dirty_init_state));
4dc34ae1b45fe2 Coly Li         2022-05-24   966  	state.c = c;
4dc34ae1b45fe2 Coly Li         2022-05-24   967  	state.d = d;
4dc34ae1b45fe2 Coly Li         2022-05-24   968  	state.total_threads = bch_btre_dirty_init_thread_nr();
4dc34ae1b45fe2 Coly Li         2022-05-24   969  	state.key_idx = 0;
4dc34ae1b45fe2 Coly Li         2022-05-24   970  	spin_lock_init(&state.idx_lock);
4dc34ae1b45fe2 Coly Li         2022-05-24   971  	atomic_set(&state.started, 0);
4dc34ae1b45fe2 Coly Li         2022-05-24   972  	atomic_set(&state.enough, 0);
4dc34ae1b45fe2 Coly Li         2022-05-24   973  	init_waitqueue_head(&state.wait);
b144e45fc57649 Coly Li         2020-03-22   974  
4dc34ae1b45fe2 Coly Li         2022-05-24   975  	for (i = 0; i < state.total_threads; i++) {
4dc34ae1b45fe2 Coly Li         2022-05-24   976  		/* Fetch latest state.enough earlier */
eb9b6666d6ca6f Coly Li         2020-03-22   977  		smp_mb__before_atomic();
4dc34ae1b45fe2 Coly Li         2022-05-24   978  		if (atomic_read(&state.enough))
b144e45fc57649 Coly Li         2020-03-22   979  			break;
b144e45fc57649 Coly Li         2020-03-22   980  
4dc34ae1b45fe2 Coly Li         2022-05-24   981  		state.infos[i].state = &state;
4dc34ae1b45fe2 Coly Li         2022-05-24   982  		state.infos[i].thread =
4dc34ae1b45fe2 Coly Li         2022-05-24   983  			kthread_run(bch_dirty_init_thread, &state.infos[i],
4dc34ae1b45fe2 Coly Li         2022-05-24   984  				    "bch_dirtcnt[%d]", i);
4dc34ae1b45fe2 Coly Li         2022-05-24   985  		if (IS_ERR(state.infos[i].thread)) {
46f5aa8806e34f Joe Perches     2020-05-27   986  			pr_err("fails to run thread bch_dirty_init[%d]\n", i);
b144e45fc57649 Coly Li         2020-03-22   987  			for (--i; i >= 0; i--)
4dc34ae1b45fe2 Coly Li         2022-05-24   988  				kthread_stop(state.infos[i].thread);
1e312ee12bfc74 ZouMingzhe      2022-09-20   989  			ret = -ENOMEM;
1e312ee12bfc74 ZouMingzhe      2022-09-20   990  			goto out_wait;
b144e45fc57649 Coly Li         2020-03-22   991  		}
4dc34ae1b45fe2 Coly Li         2022-05-24   992  		atomic_inc(&state.started);
b144e45fc57649 Coly Li         2020-03-22   993  	}
b144e45fc57649 Coly Li         2020-03-22   994  
1e312ee12bfc74 ZouMingzhe      2022-09-20   995  out_wait:
4dc34ae1b45fe2 Coly Li         2022-05-24   996  	/* Must wait for all threads to stop. */
4dc34ae1b45fe2 Coly Li         2022-05-24   997  	wait_event(state.wait, atomic_read(&state.started) == 0);
1e312ee12bfc74 ZouMingzhe      2022-09-20   998  
1e312ee12bfc74 ZouMingzhe      2022-09-20   999  	if (ret)
1e312ee12bfc74 ZouMingzhe      2022-09-20  1000  		goto out;
1e312ee12bfc74 ZouMingzhe      2022-09-20  1001  
1e312ee12bfc74 ZouMingzhe      2022-09-20  1002  	for (i = 0; i < state.total_threads; i++) {
1e312ee12bfc74 ZouMingzhe      2022-09-20  1003  		if (state.infos[i].result) {
1e312ee12bfc74 ZouMingzhe      2022-09-20  1004  			ret = state.infos[i].result;
1e312ee12bfc74 ZouMingzhe      2022-09-20  1005  			goto out;
1e312ee12bfc74 ZouMingzhe      2022-09-20  1006  		}
1e312ee12bfc74 ZouMingzhe      2022-09-20  1007  	}
1e312ee12bfc74 ZouMingzhe      2022-09-20  1008  
1e312ee12bfc74 ZouMingzhe      2022-09-20  1009  out:
4dc34ae1b45fe2 Coly Li         2022-05-24  1010  	rw_unlock(0, c->root);
1e312ee12bfc74 ZouMingzhe      2022-09-20  1011  	return ret;
444fc0b6b167ed Kent Overstreet 2013-05-11  1012  }
444fc0b6b167ed Kent Overstreet 2013-05-11  1013  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
