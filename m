Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB7DE852F
	for <lists+linux-bcache@lfdr.de>; Tue, 29 Oct 2019 11:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbfJ2KOU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 29 Oct 2019 06:14:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24185 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725867AbfJ2KOT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Oct 2019 06:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572344058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d8A+Zm0E/ZMZLIugP0s7BpD18Q9GrvZcFUq3gVZrG6U=;
        b=YtOYDA4z2a54j8T4OiOKE+aHLUEUARTWIYgbfTn+M4YDL/oXLZi4TAzKliHAYDM+ypUaAg
        xLaqeAxpJ540bmIRXGkiiJPtiRjJv8rfWMMmXJOBuKH4lrRgdyh6Bl2bg4Ae/23AlX5oHF
        TfgO7z+BAQl1SRtuVosRpHveQyOQ/ck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-Um-C0iq-P-qwyHVtpK0x4Q-1; Tue, 29 Oct 2019 06:14:13 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2117D180496F;
        Tue, 29 Oct 2019 10:14:12 +0000 (UTC)
Received: from ming.t460p (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D76E5D9C8;
        Tue, 29 Oct 2019 10:14:00 +0000 (UTC)
Date:   Tue, 29 Oct 2019 18:13:56 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH V2] block: optimize for small BS IO
Message-ID: <20191029101356.GD20854@ming.t460p>
References: <20191029070621.1307-1-ming.lei@redhat.com>
 <20191029072745.GA4521@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20191029072745.GA4521@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: Um-C0iq-P-qwyHVtpK0x4Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Oct 29, 2019 at 12:27:45AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 29, 2019 at 03:06:21PM +0800, Ming Lei wrote:
> > __blk_queue_split() may be a bit heavy for small BS(such as 512B, or
>=20
> Maybe spell out block size.  BS has another much less nice connotation.

OK.

>=20
> > bch_bio_map() should be the only one which doesn't use bio_add_page(),
> > so force to mark bio built via bch_bio_map() as MULTI_PAGE.
>=20
> We really need to fix that up.  I had patches back in the day which
> Kent didn't particularly like for non-technical reason, that might serve
> as a starting point.
>=20
> > @@ -789,6 +794,10 @@ void __bio_add_page(struct bio *bio, struct page *=
page,
> >  =09bio->bi_iter.bi_size +=3D len;
> >  =09bio->bi_vcnt++;
> > =20
> > +=09if (!bio_flagged(bio, BIO_MULTI_PAGE) && (bio->bi_vcnt >=3D 2 ||
> > +=09=09=09=09(bio->bi_vcnt =3D=3D 1 && len > PAGE_SIZE)))
> > +=09=09bio_set_flag(bio, BIO_MULTI_PAGE);
>=20
> This looks pretty ugly and does more (and more confusing) checks than
> actually needed Maybe we need a little bio_is_multi_page helper to clean
> this up a bit:
>=20
> /*
>  * Check if the bio contains more than a page and thus needs special
>  * treatment in the bio splitting code.
>  */
> static inline bool bio_is_multi_page(struct bio *bio)
> {
> =09return bio->bi_vcnt > 1 || bio->bi_io_vec[0].bv_len > PAGE_SIZE;
> }
>=20
> and then this becomes:
>=20
> =09if (!bio_flagged(bio, BIO_MULTI_PAGE) && bio_is_multi_page(bio))
>=20
> Then again these checks are so cheap that we can just use the
> bio_is_multi_page helper directly and skip the flag entirely.

I'd suggest to not add this helper:

1) there is only one user

2) the helper has to refer to bio->bi_io_vec

However, the above check can be simplified as:

=09if (!bio_flagged(bio, BIO_MULTI_PAGE) && (bio->bi_vcnt >=3D 2 ||
=09=09=09=09bv->bv_len > PAGE_SIZE))
=09=09bio_set_flag(bio, BIO_MULTI_PAGE);

Then the check has basically zero cost since all the checked variables
are just written or read in __bio_add_page() before the check.

Thanks,
Ming

