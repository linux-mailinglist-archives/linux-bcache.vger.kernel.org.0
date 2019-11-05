Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAF3EF230
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Nov 2019 01:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbfKEAo0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 19:44:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53244 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729632AbfKEAo0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 19:44:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572914664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yQozK6kPmp1GKGc6BgECaeXe8YlQmJidrw/YnronthU=;
        b=GVfnB1KwjgqWKfEY+C9QCPItJxeiTluZugiPcMUBTHgTE9kceAz2YhTUJGr9LcHi/z4n/5
        jQLKaco+aIJlEAJdvgeDqnloGj/VGaB+AJ4M+91beeklaevYUvnt6LAXl+s9XJFGFVxKKO
        7gua5ZeHocoZRZIFH8oNYlq+IbsG24Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-tBIldPGvPNCTXREjnZ7Eow-1; Mon, 04 Nov 2019 19:44:16 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86BBE107ACC2;
        Tue,  5 Nov 2019 00:44:14 +0000 (UTC)
Received: from ming.t460p (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F36FB608A5;
        Tue,  5 Nov 2019 00:44:07 +0000 (UTC)
Date:   Tue, 5 Nov 2019 08:44:02 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH V4] block: optimize for small block size IO
Message-ID: <20191105004402.GB11436@ming.t460p>
References: <20191102072911.24817-1-ming.lei@redhat.com>
 <20191104181403.GA8984@kmo-pixel>
MIME-Version: 1.0
In-Reply-To: <20191104181403.GA8984@kmo-pixel>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: tBIldPGvPNCTXREjnZ7Eow-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Nov 04, 2019 at 01:14:03PM -0500, Kent Overstreet wrote:
> On Sat, Nov 02, 2019 at 03:29:11PM +0800, Ming Lei wrote:
> > __blk_queue_split() may be a bit heavy for small block size(such as
> > 512B, or 4KB) IO, so introduce one flag to decide if this bio includes
> > multiple page. And only consider to try splitting this bio in case
> > that the multiple page flag is set.
>=20
> So, back in the day I had an alternative approach in mind: get rid of
> blk_queue_split entirely, by pushing splitting down to the request layer =
- when
> we map the bio/request to sgl, just have it map as much as will fit in th=
e sgl
> and if it doesn't entirely fit bump bi_remaining and leave it on the requ=
est
> queue.

Many drivers don't need sgl via blk_rq_map_sg(), but still need to split bi=
o.

>=20
> This would mean there'd be no need for counting segments at all, and woul=
d cut a
> fair amount of code out of the io path.

No counting segments involved in this small block size case, the handling
in blk_bio_segment_split() should be simple enough, still not understand
why IOPS drop is observable.

Thanks,
Ming

