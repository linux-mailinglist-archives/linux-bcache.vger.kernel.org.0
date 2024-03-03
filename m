Return-Path: <linux-bcache+bounces-283-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8C6C86F5BD
	for <lists+linux-bcache@lfdr.de>; Sun,  3 Mar 2024 16:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DAC52862A0
	for <lists+linux-bcache@lfdr.de>; Sun,  3 Mar 2024 15:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27E967A13;
	Sun,  3 Mar 2024 15:12:57 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F3C5A0FA;
	Sun,  3 Mar 2024 15:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709478777; cv=none; b=ms0V7t6o2Z4WODmB1SJMj5uClAEZlQBarwat+HREbhQDa+E2u3nsUmCGZmed7oOzr7i5FwYn0R4ARCJaPGv+ZVayRGKnSqQXJVbhlHg1jgV1ZjQcYQbI8r7SipVrntMV5ZmccbuPmUZ6g4Imyfzd61QdO6SV4q0mYXK2hNC1Xak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709478777; c=relaxed/simple;
	bh=luTPmbEx/8SZb1oZL5uy8youk65sn8/HT17I2W0aKOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DUza8Qg+nGygWLnCP32FwbQCJxtckbQxUhmeluSrM3Uzbx2HQTcON2QTpp17XJfa+Z+nOrgVWGGF3zUx2uo75FDo3gV0P0tbQlSJ6Hs2d+xalAiT3aEYHPBkRc7VLDc7DK3QiP6p4myns5tIYi9dI58MSZm7Shf0sMYXS8/OfsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 184F768B05; Sun,  3 Mar 2024 16:12:51 +0100 (CET)
Date: Sun, 3 Mar 2024 16:12:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@linux.dev>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: bcache queue limit cleanups
Message-ID: <20240303151250.GA27512@lst.de>
References: <20240226104826.283067-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226104826.283067-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 26, 2024 at 11:48:25AM +0100, Christoph Hellwig wrote:
> this patch against Jens' for-6.9/block tree gets rid of the last
> queue limit update in bcache by calculation the io_opt ahead of
> time.

Any chance to get this patch reviewed?  It is one of just two
queue limits API parts that still isn't reviewed.


