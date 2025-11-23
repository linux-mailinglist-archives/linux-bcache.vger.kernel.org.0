Return-Path: <linux-bcache+bounces-1261-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 12219C7E170
	for <lists+linux-bcache@lfdr.de>; Sun, 23 Nov 2025 14:49:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 853C4349034
	for <lists+linux-bcache@lfdr.de>; Sun, 23 Nov 2025 13:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53536272E7C;
	Sun, 23 Nov 2025 13:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJENi/sV"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4513AB661
	for <linux-bcache@vger.kernel.org>; Sun, 23 Nov 2025 13:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763905775; cv=none; b=LZ5zBHse+PwmLynqbdDt8icn8aeRmfgP0JxUXWlzwXEGF6g12XeErdbcOSRktHiOo3gbfgf9p8K12Rp1Zndb9GFhMU+ykRkPe3fGgYS+UKWP1KGzT/kbJrfd0p657mkLuS6HGcjv8DOQJW7KL/KoNcTtlToNqcV6QGqEWZLEZOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763905775; c=relaxed/simple;
	bh=lWbENcEh389vbMCqSvNUZZKi4TBeYFD6rNt9N2yVjFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjE4T3E1C2dUMQgJzMpqhfydgkAMawz5+Vf8MDjM+kTSfSobt9bzZfjVQ03k1grJBNkFVLNYVg74kDpk3LY8AmZG3LZhbgYFNy5qHfg1dhpXLc7BhsIaxRPgonl1X4VEAdSS35xQ/UgOHDb7Q83JfYgwFteOEvklxtgErMUBzuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gJENi/sV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763905765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4hRt8RZtumHYeZ62c0KfBKB9aID9kM568jUutNHXhRA=;
	b=gJENi/sV2+UcrgMpFIm4Vnd64dYvWYu3MEcV6w2FQySZtQyiZqZ9Y6DHfrKz2yr3V7dZ5Z
	WD9wMGv7FvWRgMUD4aCRifQ17t6N8NeBo0TbMtXxjx0dNeqYZ6SdVy//TFBfuOaMPK+YQj
	Fzoo/veEsvSYy/J7APlqNpbPDOK71U8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-96-JoNijKGXNZWpb1v6IBGpVw-1; Sun,
 23 Nov 2025 08:49:18 -0500
X-MC-Unique: JoNijKGXNZWpb1v6IBGpVw-1
X-Mimecast-MFC-AGG-ID: JoNijKGXNZWpb1v6IBGpVw_1763905754
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C2AF180045C;
	Sun, 23 Nov 2025 13:49:13 +0000 (UTC)
Received: from fedora (unknown [10.72.116.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E12D91800451;
	Sun, 23 Nov 2025 13:49:02 +0000 (UTC)
Date: Sun, 23 Nov 2025 21:48:56 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Stephen Zhang <starzhangzsd@gmail.com>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn,
	Coly Li <colyli@fnnas.com>, linux-bcache@vger.kernel.org
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO
 Chain Handling
Message-ID: <aSMQyCJrqbIromUd@fedora>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSEvg8z9qxSwJmZn@fedora>
 <CANubcdULTQo5jF7hGSWFqXw6v5DhEg=316iFNipMbsyz64aneg@mail.gmail.com>
 <aSGmBAP0BA_2D3Po@fedora>
 <CAHc6FU7+riVQBX7L2uk64A355rF+DfQ6xhP425ruQ76d_SDPGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHc6FU7+riVQBX7L2uk64A355rF+DfQ6xhP425ruQ76d_SDPGA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Sat, Nov 22, 2025 at 03:56:58PM +0100, Andreas Gruenbacher wrote:
> On Sat, Nov 22, 2025 at 1:07 PM Ming Lei <ming.lei@redhat.com> wrote:
> > > static void bio_chain_endio(struct bio *bio)
> > > {
> > >         bio_endio(__bio_chain_endio(bio));
> > > }
> >
> > bio_chain_endio() never gets called really, which can be thought as `flag`,
> 
> That's probably where this stops being relevant for the problem
> reported by Stephen Zhang.
> 
> > and it should have been defined as `WARN_ON_ONCE(1);` for not confusing people.
> 
> But shouldn't bio_chain_endio() still be fixed to do the right thing
> if called directly, or alternatively, just BUG()? Warning and still
> doing the wrong thing seems a bit bizarre.

IMO calling ->bi_end_io() directly shouldn't be encouraged.

The only in-tree direct call user could be bcache, so is this reported
issue triggered on bcache?

If bcache can't call bio_endio(), I think it is fine to fix
bio_chain_endio().

> 
> I also see direct bi_end_io calls in erofs_fileio_ki_complete(),
> erofs_fscache_bio_endio(), and erofs_fscache_submit_bio(), so those
> are at least confusing.

All looks FS bio(non-chained), so bio_chain_endio() shouldn't be involved
in erofs code base.


Thanks,
Ming


