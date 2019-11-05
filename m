Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B273DEF3A7
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Nov 2019 03:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbfKECq6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 21:46:58 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32074 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728351AbfKECq6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 21:46:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572922017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I9r54rESWvpw1cpbrFlu4EW02FtYBcPnXwSl3faToBU=;
        b=cDiTKR8XWRCsfwZ+rBKnvxgdhr4vcU1ylN3BDroVaf6JMl4bxI+CMP+hedlhvz1MfNfxlI
        9uyrXqS+q1STxCCXww+nJbQokPR5my16Dzz38FvVSkpdLnVfctfI3B0JjouEcOz2WklWQs
        uKurQCTerLrAn24QvXMfyYrs335gLNk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-JQWeylAMOSmhaYTNpzKDvg-1; Mon, 04 Nov 2019 21:46:55 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13E78800C73;
        Tue,  5 Nov 2019 02:46:54 +0000 (UTC)
Received: from ming.t460p (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D94D160FC1;
        Tue,  5 Nov 2019 02:46:46 +0000 (UTC)
Date:   Tue, 5 Nov 2019 10:46:41 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH V4] block: optimize for small block size IO
Message-ID: <20191105024641.GG11436@ming.t460p>
References: <20191102072911.24817-1-ming.lei@redhat.com>
 <20191104181403.GA8984@kmo-pixel>
 <20191104181541.GA21116@infradead.org>
 <20191104181742.GC8984@kmo-pixel>
 <f7fab4e0-58e4-76e4-a503-bb535b2a3da6@kernel.dk>
 <20191104184217.GD8984@kmo-pixel>
 <20191105011135.GD11436@ming.t460p>
 <20191105021130.GB18564@moria.home.lan>
 <20191105022046.GF11436@ming.t460p>
 <20191105023002.GC18564@moria.home.lan>
MIME-Version: 1.0
In-Reply-To: <20191105023002.GC18564@moria.home.lan>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: JQWeylAMOSmhaYTNpzKDvg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Nov 04, 2019 at 09:30:02PM -0500, Kent Overstreet wrote:
> On Tue, Nov 05, 2019 at 10:20:46AM +0800, Ming Lei wrote:
> > On Mon, Nov 04, 2019 at 09:11:30PM -0500, Kent Overstreet wrote:
> > > On Tue, Nov 05, 2019 at 09:11:35AM +0800, Ming Lei wrote:
> > > > On Mon, Nov 04, 2019 at 01:42:17PM -0500, Kent Overstreet wrote:
> > > > > On Mon, Nov 04, 2019 at 11:23:42AM -0700, Jens Axboe wrote:
> > > > > > On 11/4/19 11:17 AM, Kent Overstreet wrote:
> > > > > > > On Mon, Nov 04, 2019 at 10:15:41AM -0800, Christoph Hellwig w=
rote:
> > > > > > >> On Mon, Nov 04, 2019 at 01:14:03PM -0500, Kent Overstreet wr=
ote:
> > > > > > >>> On Sat, Nov 02, 2019 at 03:29:11PM +0800, Ming Lei wrote:
> > > > > > >>>> __blk_queue_split() may be a bit heavy for small block siz=
e(such as
> > > > > > >>>> 512B, or 4KB) IO, so introduce one flag to decide if this =
bio includes
> > > > > > >>>> multiple page. And only consider to try splitting this bio=
 in case
> > > > > > >>>> that the multiple page flag is set.
> > > > > > >>>
> > > > > > >>> So, back in the day I had an alternative approach in mind: =
get rid of
> > > > > > >>> blk_queue_split entirely, by pushing splitting down to the =
request layer - when
> > > > > > >>> we map the bio/request to sgl, just have it map as much as =
will fit in the sgl
> > > > > > >>> and if it doesn't entirely fit bump bi_remaining and leave =
it on the request
> > > > > > >>> queue.
> > > > > > >>>
> > > > > > >>> This would mean there'd be no need for counting segments at=
 all, and would cut a
> > > > > > >>> fair amount of code out of the io path.
> > > > > > >>
> > > > > > >> I thought about that to, but it will take a lot more effort.=
  Mostly
> > > > > > >> because md/dm heavily rely on splitting as well.  I still th=
ink it is
> > > > > > >> worthwhile, it will just take a significant amount of time a=
nd we
> > > > > > >> should have the quick improvement now.
> > > > > > >=20
> > > > > > > We can do it one driver at a time - driver sets a flag to dis=
able
> > > > > > > blk_queue_split(). Obvious one to do first would be nvme sinc=
e that's where it
> > > > > > > shows up the most.
> > > > > > >=20
> > > > > > > And md/md do splitting internally, but I'm not so sure they n=
eed
> > > > > > > blk_queue_split().
> > > > > >=20
> > > > > > I'm a big proponent of doing something like that instead, but i=
t is a
> > > > > > lot of work. I absolutely hate the splitting we're doing now, e=
ven
> > > > > > though the original "let's work as hard as we add add page time=
 to get
> > > > > > things right" was pretty abysmal as well.
> > > > >=20
> > > > > Last I looked I don't think it was going to be that bad, just nee=
ded a bit of
> > > > > finesse. We just need to be able to partially process a request i=
n e.g.
> > > > > nvme_map_data(), and blk_rq_map_sg() needs to be modified to only=
 map as much as
> > > > > will fit instead of popping an assertion.
> > > >=20
> > > > I think it may not be doable.
> > > >=20
> > > > blk_rq_map_sg() is called by drivers and has to work on single requ=
est, however
> > > > more requests have to be involved if we delay the splitting to blk_=
rq_map_sg().
> > > > Cause splitting means that two bios can't be submitted in single IO=
 request.
> > >=20
> > > Of course it's doable, do I have to show you how?
> >=20
> > No, you don't have to, could you just point out where my above words is=
 wrong?
>=20
> blk_rq_map_sg() _currently_ works on a single request, but as I said from=
 the
> start that this would involve changing it to only process as much of a re=
quest
> as would fit on an sglist.

> Drivers will have to be modified, but the changes to driver code should b=
e
> pretty easy. What will be slightly trickier will be changing blk-mq to ha=
ndle
> requests that are only partially completed; that will be harder than it w=
ould
> have been before blk-mq, since the old request queue code used to handle
> partially completed requests - not much work would have to be done that c=
ode.

Looks you are suggesting partial request completion.

Then the biggest effect could be in performance, this change will cause the
whole FS bio is handled part by part serially, instead of submitting all
splitted bios(part) concurrently.

So sounds you are suggesting to fix one performance issue by causing new pe=
rf
issue, is that doable?


Thanks,
Ming

