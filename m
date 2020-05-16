Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA941D621C
	for <lists+linux-bcache@lfdr.de>; Sat, 16 May 2020 17:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgEPPgw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 16 May 2020 11:36:52 -0400
Received: from verein.lst.de ([213.95.11.211]:60853 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgEPPgw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 11:36:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9732568B05; Sat, 16 May 2020 17:36:49 +0200 (CEST)
Date:   Sat, 16 May 2020 17:36:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        damien.lemoal@wdc.com, hare@suse.com, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, kbusch@kernel.org,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Message-ID: <20200516153649.GB16693@lst.de>
References: <20200516035434.82809-1-colyli@suse.de> <20200516035434.82809-2-colyli@suse.de> <20200516123801.GB13448@lst.de> <fc0fd3c9-ea46-7c62-2a57-abd64e79cd08@suse.de> <20200516125027.GA13730@lst.de> <f57da1e7-1563-db1e-8730-8daca219cbe7@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f57da1e7-1563-db1e-8730-8daca219cbe7@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, May 16, 2020 at 09:05:39PM +0800, Coly Li wrote:
> On 2020/5/16 20:50, Christoph Hellwig wrote:
> > On Sat, May 16, 2020 at 08:44:45PM +0800, Coly Li wrote:
> >> Yes you are right, just like REQ_OP_DISCARD which does not transfer any
> >> data but changes the data on device. If the request changes the stored
> >> data, it does transfer data.
> > 
> > REQ_OP_DISCARD is a special case, because most implementation end up
> > transferring data, it just gets attached in the low-level driver.
> > 
> 
> Yes, REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL are quite similar to
> REQ_OP_DISCARD. Data read from the LBA range of reset zone is not
> suggested and the content is undefined.
> 
> For bcache, similar to REQ_OP_DISCARD, REQ_OP_ZONE_RESET and
> REQ_OP_ZONE_RESET_ALL are handled in same way: If the backing device
> supports discard/zone_reset, and the operation successes, then cached
> data on SSD covered by the LBA range should be invalid, otherwise users
> will read outdated and garbage data.
> 
> We should treat REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL being in
> WRITE direction.

No, the difference is that the underlying SCSI/ATA/NVMe command tend to
usually actually transfer data.  Take a look at the special_vec field
in struct request and the RQF_SPECIAL_PAYLOAD flag.
