Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691782DF97E
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Dec 2020 08:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgLUHgD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 21 Dec 2020 02:36:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:52600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgLUHgD (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Dec 2020 02:36:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D069DACF5;
        Mon, 21 Dec 2020 07:35:21 +0000 (UTC)
Subject: Re: [PATCH] bcache: Trivial fix to bdput
To:     Yi Li <yili@winhong.com>
Cc:     yilikernel@gmail.com, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201221031739.563404-1-yili@winhong.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <4891349b-2136-eb8b-758d-f937b558b1c0@suse.de>
Date:   Mon, 21 Dec 2020 15:35:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201221031739.563404-1-yili@winhong.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/21/20 11:17 AM, Yi Li wrote:
> Trivial fix to bdput.
> 
> Signed-off-by: Yi Li <yili@winhong.com>e

Hi Yi,

Indeed these two fixes are not that trivial. I suggest to describe more
detail about why your fixes are necessary and what problems are fixed by
your patches.


Thanks.

Coly Li


> ---
>  drivers/md/bcache/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index f7ad1e26b013..1756f6926098 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2525,8 +2525,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  			else
>  				err = "device busy";
>  			mutex_unlock(&bch_register_lock);
> -			if (!IS_ERR(bdev))
> -				bdput(bdev);
> +			if (!IS_ERR(dev))
> +				bdput(dev);
>  			if (attr == &ksysfs_register_quiet)
>  				goto done;
>  		}
> 

