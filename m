Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A293647EB
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Apr 2021 18:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhDSQGE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Apr 2021 12:06:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:54124 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232161AbhDSQEq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Apr 2021 12:04:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 26BC0AF48;
        Mon, 19 Apr 2021 16:04:15 +0000 (UTC)
Subject: Re: [PATCH][next] bcache: Set error return err to -ENOMEM on
 allocation failure
To:     Colin King <colin.king@canonical.com>
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kent.overstreet@gmail.com>
References: <20210419125628.177047-1-colin.king@canonical.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <85f515b5-05a0-5844-bed7-0287f845f491@suse.de>
Date:   Tue, 20 Apr 2021 00:04:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210419125628.177047-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/19/21 8:56 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently when ns fails to be allocated the error return path returns
> an uninitialized return code in variable 'err'. Fix this by setting
> err to -ENOMEM.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: 688330711e9a ("bcache: initialize the nvm pages allocator")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/md/bcache/nvm-pages.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> index 08cd45e90481..2e124d546099 100644
> --- a/drivers/md/bcache/nvm-pages.c
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -584,6 +584,7 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
>  		return ERR_PTR(PTR_ERR(bdev));
>  	}
>  
> +	err = -ENOMEM;
>  	ns = kzalloc(sizeof(struct bch_nvm_namespace), GFP_KERNEL);
>  	if (!ns)
>  		goto bdput;
> 

Copied, added into my queue for rc1.

Thanks.

Coly Li
