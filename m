Return-Path: <linux-bcache+bounces-908-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C225DA965F7
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Apr 2025 12:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFE7A17A081
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Apr 2025 10:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E635211499;
	Tue, 22 Apr 2025 10:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qi5PahEO"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FDA2116EB
	for <linux-bcache@vger.kernel.org>; Tue, 22 Apr 2025 10:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745317791; cv=none; b=RKrFp1C5md1jUBQ+pyu5MyC+c/t5ViHZbAGpVGq8iLAdyLVA1RG7CYjFYniGNygJgJ2IQhg9QT3/RQOOsiJuSrHseHACw/HKZ6qav0fsq0K/yVC1XBkNl6RR/v4XzGyO3ey6z+Zq4S0S3W32fWzp2yp4fCK2EiRo9YLvtOIVgHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745317791; c=relaxed/simple;
	bh=ySDR+naf00yDu9P1Ud7R7ThyQJxoS7alGqqWjN3bylU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZDEywScpfLXMU3SvmPfVlilTCl+HB2Ak8PtEdUDV9vCj++Tdz7fEHDr5l27ClwbcRkzaVc2+7i6E/c+3sGz60CDhR83GR6UYNsnyTCgDE7oW9i3Hmyo+FsbdJB+jOlool2YD5vjZwunuwOmyfCBb548lResRm7CeEH+KftMlqbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qi5PahEO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745317788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=unMzrw2kDN7wNfld1j7GnlAT292MaQ581CLATXFODK0=;
	b=Qi5PahEOsTm0L6uPRjAV8uRObyRHObzb4C2W2ChMnxLXcdquiThYYEbcXyNkBkD8UM7dhA
	RveXcgMcssHJ6i4ELy3hJYLTggUzhtL2oi+81DELNSvU/Vyae8eu3sN4faOUOqRUeaJpp3
	chPF84Wtc4ZMFWaU9sxtjmtgVX60AX0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-2itJwe45P8u0rOjBPWqfaA-1; Tue,
 22 Apr 2025 06:29:43 -0400
X-MC-Unique: 2itJwe45P8u0rOjBPWqfaA-1
X-Mimecast-MFC-AGG-ID: 2itJwe45P8u0rOjBPWqfaA_1745317781
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D6AC180036D;
	Tue, 22 Apr 2025 10:29:40 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 358A7180094C;
	Tue, 22 Apr 2025 10:29:33 +0000 (UTC)
Date: Tue, 22 Apr 2025 12:29:27 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <dan.j.williams@intel.com>, 
    hch@lst.de, gregory.price@memverge.com, John@groves.net, 
    Jonathan.Cameron@huawei.com, bbhushan2@marvell.com, chaitanyak@nvidia.com, 
    rdunlap@infradead.org, agk@redhat.com, snitzer@kernel.org, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-cxl@vger.kernel.org, linux-bcache@vger.kernel.org, 
    nvdimm@lists.linux.dev, dm-devel@lists.linux.dev
Subject: Re: [RFC PATCH 00/11] pcache: Persistent Memory Cache for Block
 Devices
In-Reply-To: <235030ca-93a4-4666-93f8-93f8d81ff650@linux.dev>
Message-ID: <3bdad772-9710-2763-c9a3-fefb3723fdf6@redhat.com>
References: <20250414014505.20477-1-dongsheng.yang@linux.dev> <67fe9ea2850bc_71fe294d8@dwillia2-xfh.jf.intel.com.notmuch> <15e2151a-d788-48eb-8588-1d9a930c64dd@kernel.dk> <07f93a57-6459-46e2-8ee3-e0328dd67967@linux.dev> <d3231630-9445-4c17-9151-69fe5ae94a0d@kernel.dk>
 <235030ca-93a4-4666-93f8-93f8d81ff650@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-2131032953-1745317780=:1888132"
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-2131032953-1745317780=:1888132
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi


On Thu, 17 Apr 2025, Dongsheng Yang wrote:

> +ccing md-devel
> 
> On 2025/4/16 23:10, Jens Axboe wrote:
> > On 4/16/25 12:08 AM, Dongsheng Yang wrote:
> > > On 2025/4/16 9:04, Jens Axboe wrote:
> > > > On 4/15/25 12:00 PM, Dan Williams wrote:
> > > > > Thanks for making the comparison chart. The immediate question this
> > > > > raises is why not add "multi-tree per backend", "log structured
> > > > > writeback", "readcache", and "CRC" support to dm-writecache?
> > > > > device-mapper is everywhere, has a long track record, and enhancing it
> > > > > immediately engages a community of folks in this space.
> > > > Strongly agree.
> > > 
> > > Hi Dan and Jens,
> > > Thanks for your reply, that's a good question.
> > > 
> > >      1. Why not optimize within dm-writecache?
> > >  From my perspective, the design goal of dm-writecache is to be a
> > > minimal write cache. It achieves caching by dividing the cache device
> > > into n blocks, each managed by a wc_entry, using a very simple
> > > management mechanism. On top of this design, it's quite difficult to
> > > implement features like multi-tree structures, CRC, or log-structured
> > > writeback. Moreover, adding such optimizations?especially a read
> > > cache?would deviate from the original semantics of dm-writecache. So,
> > > we didn't consider optimizing dm-writecache to meet our goals.
> > > 
> > >      2. Why not optimize within bcache or dm-cache?
> > > As mentioned above, dm-writecache is essentially a minimal write
> > > cache. So, why not build on bcache or dm-cache, which are more
> > > complete caching systems? The truth is, it's also quite difficult.
> > > These systems were designed with traditional SSDs/NVMe in mind, and
> > > many of their design assumptions no longer hold true in the context of
> > > PMEM. Every design targets a specific scenario, which is why, even
> > > with dm-cache available, dm-writecache emerged to support DAX-capable
> > > PMEM devices.
> > > 
> > >      3. Then why not implement a full PMEM cache within the dm framework?
> > > In high-performance IO scenarios?especially with PMEM hardware?adding
> > > an extra DM layer in the IO stack is often unnecessary. For example,
> > > DM performs a bio clone before calling __map_bio(clone) to invoke the
> > > target operation, which introduces overhead.

Device mapper performs (in the common fast case) one allocation per 
incoming bio - the allocation contains the outgoing bio and a structure 
that may be used for any purpose by the target driver. For interlocking, 
it uses RCU, so there is no synchronizing instruction. So, DM overhead is 
not big.

> > > Thank you again for the suggestion. I absolutely agree that leveraging
> > > existing frameworks would be helpful in terms of code review, and
> > > merging. I, more than anyone, hope more people can help review the
> > > code or join in this work. However, I believe that in the long run,
> > > building a standalone pcache module is a better choice.
> > I think we'd need much stronger reasons for NOT adopting some kind of dm
> > approach for this, this is really the place to do it. If dm-writecache
> > etc aren't a good fit, add a dm-whatevercache for it? If dm is
> > unnecessarily cloning bios when it doesn't need to, then that seems like
> > something that would be worthwhile fixing in the first place, or at
> > least eliminate for cases that don't need it. That'd benefit everyone,
> > and we would not be stuck with a new stack to manage.
> > 
> > Would certainly be worth exploring with the dm folks.
> 
> well, introducing dm-pcache (assuming we use this name) could, on one hand,
> attract more users and developers from the device-mapper community to pay
> attention to this project, and on the other hand, serve as a way to validate
> or improve the dm framework’s performance in high-performance I/O scenarios.
> If necessary, we can enhance the dm framework instead of bypassing it
> entirely. This indeed sounds like something that would “benefit everyone.”
> 
> Hmm, I will seriously consider this approach.
> 
> Hi Alasdair, Mike, Mikulas,  Do you have any suggestions?
> 
> Thanx

If you create a new self-contained target that doesn't need changes in the 
generic dm or block code, it's OK and I would accept that.

Improving dm-writecache is also possible.

Mikulas
---1463811712-2131032953-1745317780=:1888132--


