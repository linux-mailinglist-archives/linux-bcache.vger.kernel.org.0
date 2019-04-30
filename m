Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C213FB05
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Apr 2019 16:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbfD3OFe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 Apr 2019 10:05:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:46616 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726436AbfD3OFd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Apr 2019 10:05:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7314DAB9D;
        Tue, 30 Apr 2019 14:05:32 +0000 (UTC)
Subject: Re: [PATCH] bcache: remove redundant LIST_HEAD(journal) from
 run_cache_set()
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        juha.aatrokoski@aalto.fi, shhuiw@foxmail.com
References: <20190430140225.21642-1-colyli@suse.de>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <0ded62e9-6135-6da1-312d-1ceb6160c93b@suse.de>
Date:   Tue, 30 Apr 2019 22:05:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430140225.21642-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/4/30 10:02 下午, Coly Li wrote:
> Commit 95f18c9d1310 ("bcache: avoid potential memleak of list of
> journal_replay(s) in the CACHE_SYNC branch of run_cache_set") forgets
> to remove the original define of LIST_HEAD(journal), which makes
> the change no take effect. This patch removes redundant variable
> LIST_HEAD(journal) from run_cache_set(), to make Shenghui's fix
> working.
> 
> Reported-by: Juha Aatrokoski <juha.aatrokoski@aalto.fi>
> Cc: Shenghui Wang <shhuiw@foxmail.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/super.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 0ffe9acee9d8..1b63ac876169 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1800,7 +1800,6 @@ static int run_cache_set(struct cache_set *c)
>  	set_gc_sectors(c);
>  
>  	if (CACHE_SYNC(&c->sb)) {
> -		LIST_HEAD(journal);
>  		struct bkey *k;
>  		struct jset *j;
>  
> 

Hi Jens,

Please take this fix for the Linux v5.2 bcache series. It fixes a
problem from
[PATCH 18/18] bcache: avoid potential memleak of list of
journal_replay(s) in the CACHE_SYNC branch of run_cache_set
which is already in your for-next branch.

Thanks to Juha for cache this bug, and thank you in advance for taking
care of this.

-- 

Coly Li
