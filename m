Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64632EF275
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Nov 2019 02:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbfKEBLx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 20:11:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37668 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729368AbfKEBLx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 20:11:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572916311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZJe8fnu93omXpyoBWk022HUHNt3UGJEFAf/mhPLalP4=;
        b=SNj+46geEESJBaRcEH1AQX0A4EQ/IegH1ALvgdTwbqv5NHGJd2QeiZ8+iLYY6Sk8FkAXCE
        4Kgwd2nHMz5t66Qu3AyBtFF5F6Yp6G3ezz0PFFeljhjwkLBFpT0wn2Bbf/4fs8E6Aze3zF
        D2T4428w0q0ICTycE4GHzfz/2vWeXsA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-Ngv6wU6gMdGFjBk7FarjfA-1; Mon, 04 Nov 2019 20:11:48 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AD6E107ACC2;
        Tue,  5 Nov 2019 01:11:47 +0000 (UTC)
Received: from ming.t460p (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AAAF608A5;
        Tue,  5 Nov 2019 01:11:40 +0000 (UTC)
Date:   Tue, 5 Nov 2019 09:11:35 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH V4] block: optimize for small block size IO
Message-ID: <20191105011135.GD11436@ming.t460p>
References: <20191102072911.24817-1-ming.lei@redhat.com>
 <20191104181403.GA8984@kmo-pixel>
 <20191104181541.GA21116@infradead.org>
 <20191104181742.GC8984@kmo-pixel>
 <f7fab4e0-58e4-76e4-a503-bb535b2a3da6@kernel.dk>
 <20191104184217.GD8984@kmo-pixel>
MIME-Version: 1.0
In-Reply-To: <20191104184217.GD8984@kmo-pixel>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: Ngv6wU6gMdGFjBk7FarjfA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Nov 04, 2019 at 01:42:17PM -0500, Kent Overstreet wrote:
> On Mon, Nov 04, 2019 at 11:23:42AM -0700, Jens Axboe wrote:
> > On 11/4/19 11:17 AM, Kent Overstreet wrote:
> > > On Mon, Nov 04, 2019 at 10:15:41AM -0800, Christoph Hellwig wrote:
> > >> On Mon, Nov 04, 2019 at 01:14:03PM -0500, Kent Overstreet wrote:
> > >>> On Sat, Nov 02, 2019 at 03:29:11PM +0800, Ming Lei wrote:
> > >>>> __blk_queue_split() may be a bit heavy for small block size(such a=
s
> > >>>> 512B, or 4KB) IO, so introduce one flag to decide if this bio incl=
udes
> > >>>> multiple page. And only consider to try splitting this bio in case
> > >>>> that the multiple page flag is set.
> > >>>
> > >>> So, back in the day I had an alternative approach in mind: get rid =
of
> > >>> blk_queue_split entirely, by pushing splitting down to the request =
layer - when
> > >>> we map the bio/request to sgl, just have it map as much as will fit=
 in the sgl
> > >>> and if it doesn't entirely fit bump bi_remaining and leave it on th=
e request
> > >>> queue.
> > >>>
> > >>> This would mean there'd be no need for counting segments at all, an=
d would cut a
> > >>> fair amount of code out of the io path.
> > >>
> > >> I thought about that to, but it will take a lot more effort.  Mostly
> > >> because md/dm heavily rely on splitting as well.  I still think it i=
s
> > >> worthwhile, it will just take a significant amount of time and we
> > >> should have the quick improvement now.
> > >=20
> > > We can do it one driver at a time - driver sets a flag to disable
> > > blk_queue_split(). Obvious one to do first would be nvme since that's=
 where it
> > > shows up the most.
> > >=20
> > > And md/md do splitting internally, but I'm not so sure they need
> > > blk_queue_split().
> >=20
> > I'm a big proponent of doing something like that instead, but it is a
> > lot of work. I absolutely hate the splitting we're doing now, even
> > though the original "let's work as hard as we add add page time to get
> > things right" was pretty abysmal as well.
>=20
> Last I looked I don't think it was going to be that bad, just needed a bi=
t of
> finesse. We just need to be able to partially process a request in e.g.
> nvme_map_data(), and blk_rq_map_sg() needs to be modified to only map as =
much as
> will fit instead of popping an assertion.

I think it may not be doable.

blk_rq_map_sg() is called by drivers and has to work on single request, how=
ever
more requests have to be involved if we delay the splitting to blk_rq_map_s=
g().
Cause splitting means that two bios can't be submitted in single IO request=
.


Thanks,
Ming

