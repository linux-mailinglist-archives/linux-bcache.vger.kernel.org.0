Return-Path: <linux-bcache+bounces-899-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8AFA914C6
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 09:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9EB219E04E3
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 07:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7429E217F32;
	Thu, 17 Apr 2025 07:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ux08j7+l"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B712153DA;
	Thu, 17 Apr 2025 07:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744873857; cv=none; b=KioZ4Rh3xUxq47ZU++wrF0dRTipUrtG9xXn96gZt0qQHepXxHeGfRdlvpfBQKU4aC+8s6qh3T7R5eU/85QIsabkLaB+eAc5jcWEl6aem+w862DMEHOuKQZM1JpQsnREE7HgBLfAvDgrjHgqLZ7zOJD9W1BXypZXvstE/15kKtUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744873857; c=relaxed/simple;
	bh=aYAuIo7LVdzgQM2/Cl+IsgbnZZ20GzAjup2iniRCGwQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=emH0iyCmmWNBRqndV0111rk0gnIAMMP195Fw7IikegLK/ikFXoAqmvyOoItwhWxjFT726sCrRD1ffJIWy94vuv+TqoMABpi738y4MSh0Q27/gcqrtKGKD3Hscjs46q54d3v7IZXgNnWb9QsLUZ4fbXnd8mvbG6Mh7fuCg7TVS4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ux08j7+l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5799C4CEE4;
	Thu, 17 Apr 2025 07:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744873856;
	bh=aYAuIo7LVdzgQM2/Cl+IsgbnZZ20GzAjup2iniRCGwQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Ux08j7+ly7IeXhweuU6V9uUOKO6RsQHdFsue+IwskLBT5r7fZOtcpUqk9+ws3xJqF
	 UcKZv4To/uPjMzxp30mllzIZ0YqldDdZ1J5epKuTM3ep04/F1WwrxwA6yCGnSKMKxh
	 2yA2bGlSyfrpjs/Q6Od3xZz8C0GPl1R1XGdKjYOUIIDYwxidores7ok/V6c21mQ9k6
	 dqVLUkYK0QsZohYzfpa54i+fBpKL2fgV28mvSwrBI0M/fdtGc94g/efRmid3DEc/6E
	 55zGn2kiZ7tj7CUhcGvJcfoXLVtCKN3vg5H8vaL0JGCCVnazLHb0Zs6QWj7v3zL4P1
	 Y/x3LNePlQEbw==
Date: Thu, 17 Apr 2025 00:10:53 -0700
From: Kees Cook <kees@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
CC: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
Subject: Re: [PATCH] md/bcache: Mark __nonstring look-up table
User-Agent: K-9 Mail for Android
In-Reply-To: <CAMj1kXHfearSZG6TFTxxX87qmRkUmAefQm-TfPNS8j09kWxujQ@mail.gmail.com>
References: <20250416220135.work.394-kees@kernel.org> <CAMj1kXHfearSZG6TFTxxX87qmRkUmAefQm-TfPNS8j09kWxujQ@mail.gmail.com>
Message-ID: <994E520B-64B1-4387-8DFF-88755346FE55@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



On April 16, 2025 11:16:45 PM PDT, Ard Biesheuvel <ardb@kernel=2Eorg> wrot=
e:
>On Thu, 17 Apr 2025 at 00:01, Kees Cook <kees@kernel=2Eorg> wrote:
>>
>> GCC 15's new -Wunterminated-string-initialization notices that the 16
>> character lookup table "zero_uuid" (which is not used as a C-String)
>> needs to be marked as "nonstring":
>>
>> drivers/md/bcache/super=2Ec: In function 'uuid_find_empty':
>> drivers/md/bcache/super=2Ec:549:43: warning: initializer-string for arr=
ay of 'char' truncates NUL terminator but destination lacks 'nonstring' att=
ribute (17 chars into 16 available) [-Wunterminated-string-initialization]
>>   549 |         static const char zero_uuid[16] =3D "\0\0\0\0\0\0\0\0\0=
\0\0\0\0\0\0\0";
>>       |                                           ^~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~
>>
>> Add the annotation to silence the GCC warning=2E
>>
>> Signed-off-by: Kees Cook <kees@kernel=2Eorg>
>> ---
>> Cc: Coly Li <colyli@kernel=2Eorg>
>> Cc: Kent Overstreet <kent=2Eoverstreet@linux=2Edev>
>> Cc: linux-bcache@vger=2Ekernel=2Eorg
>> ---
>>  drivers/md/bcache/super=2Ec | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/super=2Ec b/drivers/md/bcache/super=2Ec
>> index e42f1400cea9=2E=2E577d048170fe 100644
>> --- a/drivers/md/bcache/super=2Ec
>> +++ b/drivers/md/bcache/super=2Ec
>> @@ -546,7 +546,7 @@ static struct uuid_entry *uuid_find(struct cache_se=
t *c, const char *uuid)
>>
>>  static struct uuid_entry *uuid_find_empty(struct cache_set *c)
>>  {
>> -       static const char zero_uuid[16] =3D "\0\0\0\0\0\0\0\0\0\0\0\0\0=
\0\0\0";
>> +       static const char zero_uuid[] __nonstring =3D "\0\0\0\0\0\0\0\0=
\0\0\0\0\0\0\0\0";
>>
>
>Just
>
>static const char zero_uuid[16] =3D {};
>
>should work fine here too=2E No need for the initializer=2E

=F0=9F=A4=A6 Yes=2E This is what I get for fixing dozens of these=2E I'll =
send a v2=2E=2E=2E

-Kees


--=20
Kees Cook

