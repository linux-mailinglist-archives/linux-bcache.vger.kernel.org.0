Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBC73097CB
	for <lists+linux-bcache@lfdr.de>; Sat, 30 Jan 2021 20:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbhA3TGo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 30 Jan 2021 14:06:44 -0500
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:42408 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229990AbhA3TGn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Jan 2021 14:06:43 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jan 2021 14:06:43 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave08.hostedemail.com (Postfix) with ESMTP id 89594182D4575
        for <linux-bcache@vger.kernel.org>; Sat, 30 Jan 2021 19:00:15 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 86FC9173085F;
        Sat, 30 Jan 2021 18:59:33 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3868:3870:3871:4321:4605:5007:7652:7875:7904:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12297:12438:12555:12740:12895:13069:13311:13357:13439:13894:14181:14659:14721:21080:21627:30046:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: hook93_0608dc9275b3
X-Filterd-Recvd-Size: 2897
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Sat, 30 Jan 2021 18:59:32 +0000 (UTC)
Message-ID: <14e1e776ceac5d4e84675bc70532aa30530eb8ec.camel@perches.com>
Subject: Re: [PATCH 13/29] bcache: Avoid comma separated statements
From:   Joe Perches <joe@perches.com>
To:     Jiri Kosina <trivial@kernel.org>, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 30 Jan 2021 10:59:31 -0800
In-Reply-To: <99ba798329f7d957e75a22c8551e8bd22f70c626.1598331149.git.joe@perches.com>
References: <cover.1598331148.git.joe@perches.com>
         <99ba798329f7d957e75a22c8551e8bd22f70c626.1598331149.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, 2020-08-24 at 21:56 -0700, Joe Perches wrote:
> Use semicolons and braces.

ping?

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/md/bcache/bset.c  | 12 ++++++++----
>  drivers/md/bcache/sysfs.c |  6 ++++--
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 67a2c47f4201..94d38e8a59b3 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -712,8 +712,10 @@ void bch_bset_build_written_tree(struct btree_keys *b)
>  	for (j = inorder_next(0, t->size);
>  	     j;
>  	     j = inorder_next(j, t->size)) {
> -		while (bkey_to_cacheline(t, k) < cacheline)
> -			prev = k, k = bkey_next(k);
> +		while (bkey_to_cacheline(t, k) < cacheline) {
> +			prev = k;
> +			k = bkey_next(k);
> +		}
>  
> 
>  		t->prev[j] = bkey_u64s(prev);
>  		t->tree[j].m = bkey_to_cacheline_offset(t, cacheline++, k);
> @@ -901,8 +903,10 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
>  	status = BTREE_INSERT_STATUS_INSERT;
>  
> 
>  	while (m != bset_bkey_last(i) &&
> -	       bkey_cmp(k, b->ops->is_extents ? &START_KEY(m) : m) > 0)
> -		prev = m, m = bkey_next(m);
> +	       bkey_cmp(k, b->ops->is_extents ? &START_KEY(m) : m) > 0) {
> +		prev = m;
> +		m = bkey_next(m);
> +	}
>  
> 
>  	/* prev is in the tree, if we merge we're done */
>  	status = BTREE_INSERT_STATUS_BACK_MERGE;
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index ac06c0bc3c0a..1878c5ee53b6 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -1071,8 +1071,10 @@ SHOW(__bch_cache)
>  			--n;
>  
> 
>  		while (cached < p + n &&
> -		       *cached == BTREE_PRIO)
> -			cached++, n--;
> +		       *cached == BTREE_PRIO) {
> +			cached++;
> +			n--;
> +		}
>  
> 
>  		for (i = 0; i < n; i++)
>  			sum += INITIAL_PRIO - cached[i];


