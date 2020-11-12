Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EE42AFEA3
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Nov 2020 06:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgKLFj0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 12 Nov 2020 00:39:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:45640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728672AbgKLEMu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Nov 2020 23:12:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A4B37ABCC;
        Thu, 12 Nov 2020 04:12:48 +0000 (UTC)
Subject: Re: [PATCH 1/2] bcache: fix race between setting bdev state to none
 and new write request direct to backing
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     linux-bcache@vger.kernel.org
References: <1602661615-9715-1-git-send-email-dongsheng.yang@easystack.cn>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <b51e9d28-e657-4caf-1a16-95bf2920e741@suse.de>
Date:   Thu, 12 Nov 2020 12:12:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1602661615-9715-1-git-send-email-dongsheng.yang@easystack.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/10/14 15:46, Dongsheng Yang wrote:
> There is a race condition in detaching as below:
> A. detaching						B. Write request
> (1) writing back
> (2) write back done, set bdev state to clean.
> (3) cached_dev_put() and schedule_work(&dc->detach);
> 							(4) write data [0 - 4K] directly into backing and ack to user.
> (5) power-failure...
> 
> When we restart this bcache device, this bdev is clean but not detached, and read [0 - 4K],
> we will get unexpected old data from cache device.
> 
> To fix this problem, set the bdev state to none when we writeback done in detaching,
> and then if power-failure happend as above, the data in cache will not be used in next
> bcache device starting, it's detached, we will read the correct data from backing derectly.
> 
> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>


Hi Dongsheng,

It takes me for a while to understand and make sure the whole code flow
works correctly. Thank you for catching such a very rare problem. IMHO
this patch is cool, I will add it into the for-test queue.

Thanks.

Coly Li


> ---
>  drivers/md/bcache/super.c     | 9 ---------
>  drivers/md/bcache/writeback.c | 9 +++++++++
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 1bbdc41..9298fc7 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1128,9 +1128,6 @@ static void cancel_writeback_rate_update_dwork(struct cached_dev *dc)
>  static void cached_dev_detach_finish(struct work_struct *w)
>  {
>  	struct cached_dev *dc = container_of(w, struct cached_dev, detach);
> -	struct closure cl;
> -
> -	closure_init_stack(&cl);
>  
>  	BUG_ON(!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags));
>  	BUG_ON(refcount_read(&dc->count));
> @@ -1144,12 +1141,6 @@ static void cached_dev_detach_finish(struct work_struct *w)
>  		dc->writeback_thread = NULL;
>  	}
>  
> -	memset(&dc->sb.set_uuid, 0, 16);
> -	SET_BDEV_STATE(&dc->sb, BDEV_STATE_NONE);
> -
> -	bch_write_bdev_super(dc, &cl);
> -	closure_sync(&cl);
> -
>  	mutex_lock(&bch_register_lock);
>  
>  	calc_cached_dev_sectors(dc->disk.c);
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 4f4ad6b..2cd0340 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -705,6 +705,15 @@ static int bch_writeback_thread(void *arg)
>  			 * bch_cached_dev_detach().
>  			 */
>  			if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags)) {
> +				struct closure cl;
> +
> +				closure_init_stack(&cl);
> +				memset(&dc->sb.set_uuid, 0, 16);
> +				SET_BDEV_STATE(&dc->sb, BDEV_STATE_NONE);
> +
> +				bch_write_bdev_super(dc, &cl);
> +				closure_sync(&cl);
> +
>  				up_write(&dc->writeback_lock);
>  				break;
>  			}
> 

