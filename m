Return-Path: <linux-bcache+bounces-1031-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD62AAAC041
	for <lists+linux-bcache@lfdr.de>; Tue,  6 May 2025 11:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C3A13B5636
	for <lists+linux-bcache@lfdr.de>; Tue,  6 May 2025 09:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007AB26C381;
	Tue,  6 May 2025 09:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AceFZnBF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D1426B2D5
	for <linux-bcache@vger.kernel.org>; Tue,  6 May 2025 09:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746524375; cv=none; b=p/gAVnW89ZusvP0jK99IX8xsxhBl5ez5DNZmTvZoEl3RNeGybcAoWHry9ayRjUKyJLh2i1Ahi8LYJ+rQlhQWeIRd5f0SJEvjTzD/RnwzI01bVNWdFkyy7rLFbtfJVbt3IEG8tsz374AYFfnmNKrkRa9yjOTkVdB3ok3UJ0WgoNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746524375; c=relaxed/simple;
	bh=ddeL3+4Xwx6F8i2l6J2Sv8a8RQHIHwLek7kPAiXOVMM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Phct5IqxWdJLopSfq8OuNhdN9ucXz8P0NFMAZn+VZCjMve67AdcPAsGXDI6Zh9MBpQM5QM/Sv4X+3mPUOl++4osNBpWBsv4n8Vpag80rqWlTgFoQF0KV384WAgwOkfPs7aRgJ7EJTj4U0mJYylKzvdTF7TCbMwAZdqE5NevwykU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AceFZnBF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746524373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WCH41PJGqffHSnBHBV0vSWsb+4SL3xUtY0q4b59CQS4=;
	b=AceFZnBFBsXb8lvFqtS0XDoUeJtfpyE3C6G8m8b6H2Xx99dYPlTvLlbAmFZccvH8LscN8E
	2U94TuRIE4RaAdl75S9gnHhGXebULHiqUlEqC9x8JbuPFw5smjzcMVrLkj0u8S+MQMa58K
	kgIdvQ3B9dSz5Jzflkt2O2NJerQ9M68=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-p-oLq_gOMhmKBu2I3DM2IQ-1; Tue,
 06 May 2025 05:39:32 -0400
X-MC-Unique: p-oLq_gOMhmKBu2I3DM2IQ-1
X-Mimecast-MFC-AGG-ID: p-oLq_gOMhmKBu2I3DM2IQ_1746524368
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6C061801A2B;
	Tue,  6 May 2025 09:39:27 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57D821956094;
	Tue,  6 May 2025 09:39:20 +0000 (UTC)
Date: Tue, 6 May 2025 11:39:17 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Christoph Hellwig <hch@lst.de>
cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, 
    "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
    Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@kernel.org>, 
    Kent Overstreet <kent.overstreet@linux.dev>, 
    Mike Snitzer <snitzer@kernel.org>, Chris Mason <clm@fb.com>, 
    Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
    Andreas Gruenbacher <agruenba@redhat.com>, 
    Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
    Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
    "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, 
    slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com, 
    linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, 
    linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
    linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
    linux-pm@vger.kernel.org
Subject: Re: add more bio helpers v2
In-Reply-To: <20250506044723.GA27656@lst.de>
Message-ID: <db71b7f6-42ca-ed44-477a-19f22dbeefba@redhat.com>
References: <20250430212159.2865803-1-hch@lst.de> <20250506044723.GA27656@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15



On Tue, 6 May 2025, Christoph Hellwig wrote:

> This has maintaner ACKs for everything but the two dm and the one
> btrfs patch one.  Maybe we can queue up the series minus those three
> patches and then deal with them later?

Hi

I've just acked the two dm patches, so you can queue them.

Mikulas


