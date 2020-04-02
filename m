Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78A319C040
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Apr 2020 13:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388053AbgDBLe1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Apr 2020 07:34:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:53938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388001AbgDBLe0 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Apr 2020 07:34:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2EE3DAAB8;
        Thu,  2 Apr 2020 11:34:25 +0000 (UTC)
Subject: Re: [PATCH] bcache: remove redundant variables i and n
To:     Colin King <colin.king@canonical.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200402111903.514146-1-colin.king@canonical.com>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <de88ae08-1200-285b-cd1b-cfd723d2da56@suse.de>
Date:   Thu, 2 Apr 2020 19:34:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200402111903.514146-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/4/2 7:19 下午, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variables i and n are being assigned but are never used. They are
> redundant and can be removed.
> 

Hi Colin,

> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, I will submit this patch in Linux 5.7-rc series.

> ---
>  drivers/md/bcache/btree.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 72856e5f23a3..114d0d73d909 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1907,10 +1907,8 @@ static int bch_btree_check_thread(void *arg)
>  	struct btree_iter iter;
>  	struct bkey *k, *p;
>  	int cur_idx, prev_idx, skip_nr;
> -	int i, n;
>  
>  	k = p = NULL;
> -	i = n = 0;
>  	cur_idx = prev_idx = 0;
>  	ret = 0;
>  
> 


-- 

Coly Li
