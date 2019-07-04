Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2475F780
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jul 2019 13:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfGDLx1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 4 Jul 2019 07:53:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:50218 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727436AbfGDLx1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 Jul 2019 07:53:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 58775AF6A;
        Thu,  4 Jul 2019 11:53:26 +0000 (UTC)
Subject: Re: [PATCH -next] bcache: fix possible memory leak in
 bch_cached_dev_run()
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190704095257.143492-1-weiyongjun1@huawei.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <0652186a-7d94-103b-f7e4-168d4910f043@suse.de>
Date:   Thu, 4 Jul 2019 19:53:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704095257.143492-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/7/4 5:52 下午, Wei Yongjun wrote:
> memory malloced in bch_cached_dev_run() and should be freed before
> leaving from the error handling cases, otherwise it will cause
> memory leak.
> 
> Fixes: 0b13efecf5f2 ("bcache: add return value check to bch_cached_dev_run()")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Hi Yongjun,

Thanks for the catch, I will add it for the second submission to Linux v5.3.

Coly Li

> ---
>  drivers/md/bcache/super.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 26e374fbf57c..20ed838e9413 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -931,6 +931,9 @@ int bch_cached_dev_run(struct cached_dev *dc)
>  	if (dc->io_disable) {
>  		pr_err("I/O disabled on cached dev %s",
>  		       dc->backing_dev_name);
> +		kfree(env[1]);
> +		kfree(env[2]);
> +		kfree(buf);
>  		return -EIO;
>  	}
