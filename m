Return-Path: <linux-bcache+bounces-1184-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D6C0B209FF
	for <lists+linux-bcache@lfdr.de>; Mon, 11 Aug 2025 15:22:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92BA217AF1F
	for <lists+linux-bcache@lfdr.de>; Mon, 11 Aug 2025 13:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D91BC2DC33B;
	Mon, 11 Aug 2025 13:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rg0k5FZA"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B017C2DAFA3;
	Mon, 11 Aug 2025 13:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754918553; cv=none; b=jKfh/7xtK7PlMdPY+/PVgHm8C0N8Rb9x4Ucz7Q7+FZCTkHlWQVef2/na1NqWW3Ue7mOGoJMWWGc/4UEI0jfGphBqCzSMu5XLIJHi2TnjPlBpkvQSLoWYypUq9Sn8hXjmprluOaq2oAWrs8NXId4/iuXCXyIEVW80XBTKyORtv2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754918553; c=relaxed/simple;
	bh=gZOYa/4FyvXPOv9JnL+tuX3O6cu0SV5qWCX5UquAPGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZmD4cDcqwLQoi7a/FFxeZqRAvKYA//oNnBvBmOyorESfymO27q6OQ+N027Y4V8RlZJK8Gk56NPe+M+lV57Sdi8klDl4zwQ3p+MtkoY0aB3pLf8K6YwSzF8MeWFouxEXZBPEs7wfOQH88MIx7GbAo6YQlQhD92gXWl/k86x/WTGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rg0k5FZA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6392C4CEED;
	Mon, 11 Aug 2025 13:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754918553;
	bh=gZOYa/4FyvXPOv9JnL+tuX3O6cu0SV5qWCX5UquAPGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rg0k5FZAiXXJA0POYxvBOUpVcSg4JITf846hK+eDZ78Gqee3te+rEOft34U4pOD8e
	 6UAg7FFAx+oYAmP4szLouhIuAkgpLHVH9CK8gieUOE93Pa1GwOfEZieXmzfRgYzxG0
	 oxvAK+s305VAGlaB2oO07+2del2/MqGjeAiyKkm2sw3n99nmRsY9cET6kq9AjFunGN
	 d+gz94SObgOOeOQR0jbphdrqKCuDHjddGglBF8/2iJEkN+zyij7hIOETBTwa9tkVk7
	 hE158/6pVbG3Df7RDRRx/idYhEU4hqB9rosNzrwYO5dM7W992NdFy2jd0Fu/fL9dTV
	 LWOktc/XS2qBg==
Date: Mon, 11 Aug 2025 21:22:28 +0800
From: Coly Li <colyli@kernel.org>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	"open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] bcache: remove redundant __GFP_NOWARN
Message-ID: <xgpbwq3j3hlowxo2efk46rzdku6ueevgxl6cb5baqgyqanwtzv@e72yn2apzqrd>
References: <20250811123638.550822-1-rongqianfeng@vivo.com>
 <20250811123638.550822-2-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811123638.550822-2-rongqianfeng@vivo.com>

On Mon, Aug 11, 2025 at 08:36:35PM +0800, Qianfeng Rong wrote:
> GFP_NOWAIT already includes __GFP_NOWARN, so let's remove the redundant
> __GFP_NOWARN.
> 
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>

Acked-by: Coly Li <colyli@kernel.org>

Do you want this patch to go upstream in my submission path?

Thanks.

Coly Li

> ---
>  drivers/md/bcache/btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 210b59007d98..a764ec149d7a 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -371,7 +371,7 @@ static void do_btree_node_write(struct btree *b)
>  	SET_PTR_OFFSET(&k.key, 0, PTR_OFFSET(&k.key, 0) +
>  		       bset_sector_offset(&b->keys, i));
>  
> -	if (!bch_bio_alloc_pages(b->bio, __GFP_NOWARN|GFP_NOWAIT)) {
> +	if (!bch_bio_alloc_pages(b->bio, GFP_NOWAIT)) {
>  		struct bio_vec *bv;
>  		void *addr = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
>  		struct bvec_iter_all iter_all;
> -- 
> 2.34.1
> 

