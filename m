Return-Path: <linux-bcache+bounces-743-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41BEF98A837
	for <lists+linux-bcache@lfdr.de>; Mon, 30 Sep 2024 17:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E694F1F24336
	for <lists+linux-bcache@lfdr.de>; Mon, 30 Sep 2024 15:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 002701922E6;
	Mon, 30 Sep 2024 15:11:14 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from albert.telenet-ops.be (albert.telenet-ops.be [195.130.137.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF57D1922E3
	for <linux-bcache@vger.kernel.org>; Mon, 30 Sep 2024 15:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.137.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727709073; cv=none; b=Kw+pVyUHS5TV5NNwD9C6m084QWV5u8StWWS5yiJImxPLv8jEwiTC76kW2CF2mTqIwRVxAcHAzTByT1RA2v7EGoPy6Yv9/iVIWlYkVp+E0cOzXVjUquOJKiVG5zcoyImku6eFSGn3YXtghOvVieMqpgkPVCRL14pCp7kjtlou4bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727709073; c=relaxed/simple;
	bh=Isgr67ukG7koOuAxICLN1rPhet66ZoBzVAG8X/1sAtA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=G/7Hov9rE75cSlp3+ov/YLKv5w7jPkwJ+WnZppQV7hy5MgZ6Gpc0fjG/JsmlQQgs56NMwE5eiFJbucR4QgSJytdfAHkYfTG2O5GUKE+puED3RdQ0ScjdvxTw/vD5ZX0MIdr+oKrDrG8bH/9a/HFLUN0Mwofo0zVVS+1igSHDmcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.137.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:99bb:7ad4:7fac:370a])
	by albert.telenet-ops.be with cmsmtp
	id JfB92D00Y4pGYif06fB9DU; Mon, 30 Sep 2024 17:11:09 +0200
Received: from geert (helo=localhost)
	by ramsan.of.borg with local-esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1svI3J-000wex-Ml;
	Mon, 30 Sep 2024 17:11:09 +0200
Date: Mon, 30 Sep 2024 17:11:09 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
cc: Kent Overstreet <kent.overstreet@linux.dev>, 
    Herve Codina <herve.codina@bootlin.com>, 
    Christophe Leroy <christophe.leroy@csgroup.eu>, 
    linux-bcache@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: Build regressions/improvements in v6.12-rc1
In-Reply-To: <20240930145322.129875-1-geert@linux-m68k.org>
Message-ID: <6464b079-372d-d3f-d774-a7c05916fbe2@linux-m68k.org>
References: <CAHk-=wiwVOCZsC6a4dLdb1UjL2fS_CnLNjrPL0XGFbDd9C26Cg@mail.gmail.com> <20240930145322.129875-1-geert@linux-m68k.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 30 Sep 2024, Geert Uytterhoeven wrote:
> Below is the list of build error/warning regressions/improvements in
> v6.12-rc1[1] compared to v6.11[2].

> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/9852d85ec9d492ebef56dc5f229416c925758edc/ (all 131 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/98f7e32f20d28ec452afb208f9cffc08448a2652/ (all 131 configs)
>
>
> *** ERRORS ***
>
> 12 error regressions:
>  + /kisskb/src/fs/bcachefs/backpointers.c: error: 'const struct bkey' has no member named 'bversion'; did you mean 'version'?:  => 504:53
>  + /kisskb/src/fs/bcachefs/bcachefs_format.h: error: 'struct bkey' has no member named 'bversion'; did you mean 'version'?:  => 332:49, 331:49
>  + /kisskb/src/fs/bcachefs/bkey.h: error: 'const struct bkey' has no member named 'bversion':  => 578:48
>  + /kisskb/src/fs/bcachefs/bkey.h: error: 'const struct bkey' has no member named 'bversion'; did you mean 'version'?:  => 558:27, 557:41, 557:27, 558:41
>  + /kisskb/src/fs/bcachefs/bkey.h: error: 'struct bkey' has no member named 'bversion'; did you mean 'version'?:  => 557:41, 558:41
>  + /kisskb/src/fs/bcachefs/bkey_methods.c: error: 'const struct bkey' has no member named 'bversion'; did you mean 'version'?:  => 292:65
>  + /kisskb/src/fs/bcachefs/bkey_methods.h: error: 'const struct bkey' has no member named 'bversion':  => 73:31, 73:18
>  + /kisskb/src/fs/bcachefs/bkey_methods.h: error: 'const struct bkey' has no member named 'bversion'; did you mean 'version'?:  => 73:33, 73:20, 73:47, 73:34
>  + /kisskb/src/fs/bcachefs/bkey_methods.h: error: control reaches end of non-void function [-Werror=return-type]:  => 75:1
>  + /kisskb/src/fs/bcachefs/disk_accounting.h: error: 'const struct bkey' has no member named 'bversion'; did you mean 'version'?:  => 40:28, 40:42, 39:50, 39:43
>  + /kisskb/src/fs/bcachefs/disk_accounting.h: error: 'struct bkey' has no member named 'bversion'; did you mean 'version'?:  => 39:26, 40:10, 39:33, 40:24

All big-endian platforms (fix available, even on a public mailing list ;-)

>  + /kisskb/src/include/linux/err.h: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]:  => 28:49

powerpc-gcc13/ppc64_book3e_allmodconfig

drivers/soc/fsl/qe/qmc.c: In function 'qmc_qe_init_resources':
include/linux/err.h:28:49: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
    28 | #define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
       |                                                 ^
include/linux/compiler.h:77:45: note: in definition of macro 'unlikely'
    77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
       |                                             ^
drivers/soc/fsl/qe/qmc.c:1764:13: note: in expansion of macro 'IS_ERR_VALUE'
  1764 |         if (IS_ERR_VALUE(info)) {
       |             ^~~~~~~~~~~~

IS_ERR_VALUE() is meant for pointers (fix available)

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds

