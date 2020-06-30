Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DBC20FB92
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Jun 2020 20:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgF3STe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 Jun 2020 14:19:34 -0400
Received: from verein.lst.de ([213.95.11.211]:36961 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgF3STe (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Jun 2020 14:19:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2C5A868B05; Tue, 30 Jun 2020 20:19:29 +0200 (CEST)
Date:   Tue, 30 Jun 2020 20:19:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
        linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: rename ->make_request_fn and move it to the
 block_device_operations
Message-ID: <20200630181928.GA7853@lst.de>
References: <20200629193947.2705954-1-hch@lst.de> <bd1443c0-be37-115b-1110-df6f0e661a50@kernel.dk> <6ddbe343-0fc2-58c8-3726-c4ba9952994f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ddbe343-0fc2-58c8-3726-c4ba9952994f@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Jun 30, 2020 at 09:43:31AM -0600, Jens Axboe wrote:
> On 6/30/20 7:57 AM, Jens Axboe wrote:
> > On 6/29/20 1:39 PM, Christoph Hellwig wrote:
> >> Hi Jens,
> >>
> >> this series moves the make_request_fn method into block_device_operations
> >> with the much more descriptive ->submit_bio name.  It then also gives
> >> generic_make_request a more descriptive name, and further optimize the
> >> path to issue to blk-mq, removing the need for the direct_make_request
> >> bypass.
> > 
> > Looks good to me, and it's a nice cleanup as well. Applied.
> 
> Dropped, insta-crashes with dm:

Hmm.  Can you send me what is at "submit_bio_noacct+0x1f6" from gdb?
Or your .config?
