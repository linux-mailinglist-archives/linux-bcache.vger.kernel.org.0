Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B8210E94F
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2019 12:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfLBLJN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Dec 2019 06:09:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:54660 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726330AbfLBLJM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Dec 2019 06:09:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 22851B2F8;
        Mon,  2 Dec 2019 11:09:11 +0000 (UTC)
Subject: Re: [PATCH] bcache: add REQ_FUA to avoid data lost in writeback mode
To:     kungf <wings.wyang@gmail.com>
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191202102409.3980-1-wings.wyang@gmail.com>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <785fe04f-f841-3083-66db-53fab7bc0577@suse.de>
Date:   Mon, 2 Dec 2019 19:08:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191202102409.3980-1-wings.wyang@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/12/2 6:24 下午, kungf wrote:
> data may lost when in the follow scene of writeback mode:
> 1. client write data1 to bcache
> 2. client fdatasync
> 3. bcache flush cache set and backing device
> if now data1 was not writed back to backing, it was only guaranteed safe in cache.
> 4.then cache writeback data1 to backing with only REQ_OP_WRITE
> So data1 was not guaranteed in non-volatile storage,  it may lost if  power interruption 
> 

Hi,

Do you encounter such problem in real work load ? With bcache journal, I
don't see the possibility of data lost with your description.

Correct me if I am wrong.

Coly Li

> Signed-off-by: kungf <wings.wyang@gmail.com>
> ---
>  drivers/md/bcache/writeback.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 4a40f9eadeaf..e5cecb60569e 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -357,7 +357,7 @@ static void write_dirty(struct closure *cl)
>  	 */
>  	if (KEY_DIRTY(&w->key)) {
>  		dirty_init(w);
> -		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
> +		bio_set_op_attrs(&io->bio, REQ_OP_WRITE | REQ_FUA, 0);
>  		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
>  		bio_set_dev(&io->bio, io->dc->bdev);
>  		io->bio.bi_end_io	= dirty_endio;
> 

