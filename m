Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 527AF10F08B
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2019 20:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfLBTeu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Dec 2019 14:34:50 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:54947 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbfLBTeu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Dec 2019 14:34:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 5EF76A0440;
        Mon,  2 Dec 2019 19:34:44 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id uRQNVO4LW8_g; Mon,  2 Dec 2019 19:34:23 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 1F97BA0693;
        Mon,  2 Dec 2019 19:34:23 +0000 (UTC)
Date:   Mon, 2 Dec 2019 19:34:12 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Coly Li <colyli@suse.de>
cc:     kungf <wings.wyang@gmail.com>, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: add REQ_FUA to avoid data lost in writeback
 mode
In-Reply-To: <785fe04f-f841-3083-66db-53fab7bc0577@suse.de>
Message-ID: <alpine.LRH.2.11.1912021932570.11561@mx.ewheeler.net>
References: <20191202102409.3980-1-wings.wyang@gmail.com> <785fe04f-f841-3083-66db-53fab7bc0577@suse.de>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-844282404-2137853158-1575315263=:11561"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---844282404-2137853158-1575315263=:11561
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 2 Dec 2019, Coly Li wrote:
> On 2019/12/2 6:24 下午, kungf wrote:
> > data may lost when in the follow scene of writeback mode:
> > 1. client write data1 to bcache
> > 2. client fdatasync
> > 3. bcache flush cache set and backing device
> > if now data1 was not writed back to backing, it was only guaranteed safe in cache.
> > 4.then cache writeback data1 to backing with only REQ_OP_WRITE
> > So data1 was not guaranteed in non-volatile storage,  it may lost if  power interruption 
> > 
> 
> Hi,
> 
> Do you encounter such problem in real work load ? With bcache journal, I
> don't see the possibility of data lost with your description.
> 
> Correct me if I am wrong.
> 
> Coly Li

If this does become necessary, then we should have a sysfs or superblock 
flag to disable FUA for those with RAID BBUs.

--
Eric Wheeler




> > Signed-off-by: kungf <wings.wyang@gmail.com>
> > ---
> >  drivers/md/bcache/writeback.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> > index 4a40f9eadeaf..e5cecb60569e 100644
> > --- a/drivers/md/bcache/writeback.c
> > +++ b/drivers/md/bcache/writeback.c
> > @@ -357,7 +357,7 @@ static void write_dirty(struct closure *cl)
> >  	 */
> >  	if (KEY_DIRTY(&w->key)) {
> >  		dirty_init(w);
> > -		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
> > +		bio_set_op_attrs(&io->bio, REQ_OP_WRITE | REQ_FUA, 0);
> >  		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
> >  		bio_set_dev(&io->bio, io->dc->bdev);
> >  		io->bio.bi_end_io	= dirty_endio;
> > 
> 
> 
---844282404-2137853158-1575315263=:11561--
