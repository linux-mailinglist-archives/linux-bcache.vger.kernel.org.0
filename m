Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83DF8EA8D3
	for <lists+linux-bcache@lfdr.de>; Thu, 31 Oct 2019 02:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfJaBdm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 30 Oct 2019 21:33:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56318 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726336AbfJaBdm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 30 Oct 2019 21:33:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572485620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JOT5e0E88zWIKcVI9/G9U554lO8BRI016yaiVp/NwTw=;
        b=YkJ7rDaL2xARgAAApFtXXgaknKALf0FaP3UBZ9m6uRDyPgc7M2dJXM7MUMqGv7fi9F4Vm9
        3xenDwXKzolq4qyctur6+LFNSs0huTbg3siV/8MMJdlOu4w4NNRka6wUY1ppq29UVzNexP
        TPBjegQHt8yQ4/PuMaM8CS8h1axTJo4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-bJNIYacrMKifuaSjoJlzqw-1; Wed, 30 Oct 2019 21:33:37 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01CEA800D49;
        Thu, 31 Oct 2019 01:33:36 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 304A460BE0;
        Thu, 31 Oct 2019 01:33:29 +0000 (UTC)
Date:   Thu, 31 Oct 2019 09:33:25 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Keith Busch <kbusch@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH V3] block: optimize for small block size IO
Message-ID: <20191031013325.GA12309@ming.t460p>
References: <20191029105125.12928-1-ming.lei@redhat.com>
 <20191029110425.GA4382@infradead.org>
 <20191030002126.GA14423@ming.t460p>
 <20191030135426.GA24655@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20191030135426.GA24655@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: bJNIYacrMKifuaSjoJlzqw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Oct 30, 2019 at 06:54:26AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 30, 2019 at 08:21:26AM +0800, Ming Lei wrote:
> > > +=09=09if ((*bio)->bi_vcnt =3D=3D 1 &&
> > > +=09=09    (*bio)->bi_io_vec[0].bv_len <=3D PAGE_SIZE) {
> > > +=09=09=09*nr_segs =3D 1;
> > > +=09=09=09return;
> > > +=09=09}
> > >  =09=09split =3D blk_bio_segment_split(q, *bio, &q->bio_split, nr_seg=
s);
> > >  =09=09break;
> > >  =09}
> >=20
> > This bio(*bio) may be a fast-cloned bio from somewhere(DM, MD, ...), so=
 the above
> > check can't work sometime.
>=20
> Please explain how it doesn't work.  In the worse case it will give us
> a false negastive, that is we don't take the fast path when in theory
> we could, but then again fast clone=D1=95 bios will have so much overhead
> that it should not matter.

In theory, we shouldn't use fast clone bio's .bi_vcnt, so far it is
zero, in future fast clone bio's bi_vcnt might be used for other purpose.

Also this bio may not a fast cloned bio, but it has been splitted(such
as one 4k bio, and its front 512 byte is splitted out). It depends on
if the remained bio needs to be splitted again. In reality, looks it
won't be possible.

In short, the above way is like a hack, but it should work in reality.

I am fine with that, if comment of this usage is added.


Thanks,
Ming

