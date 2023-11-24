Return-Path: <linux-bcache+bounces-28-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43FD07F762D
	for <lists+linux-bcache@lfdr.de>; Fri, 24 Nov 2023 15:18:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F210C281F23
	for <lists+linux-bcache@lfdr.de>; Fri, 24 Nov 2023 14:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12AFD2D035;
	Fri, 24 Nov 2023 14:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE1919A5;
	Fri, 24 Nov 2023 06:18:05 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6E0E01FE7D;
	Fri, 24 Nov 2023 14:18:04 +0000 (UTC)
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id BCFCE139E8;
	Fri, 24 Nov 2023 14:18:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id l0A5GpiwYGXWIAAAn2gu4w
	(envelope-from <colyli@suse.de>); Fri, 24 Nov 2023 14:18:00 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.200.91.1.1\))
Subject: Re: bcache: kernel NULL pointer dereference since 6.1.39
From: Coly Li <colyli@suse.de>
In-Reply-To: <1c2a1f362d667d36d83a5ba43218bad199855b11.camel@gekmihesg.de>
Date: Fri, 24 Nov 2023 22:17:46 +0800
Cc: Thorsten Leemhuis <regressions@leemhuis.info>,
 Zheng Wang <zyytlz.wz@163.com>,
 linux-kernel@vger.kernel.org,
 =?utf-8?Q?Stefan_F=C3=B6rster?= <cite@incertum.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Jens Axboe <axboe@kernel.dk>,
 Linux kernel regressions list <regressions@lists.linux.dev>,
 Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3DF4A87A-2AC1-4893-AE5F-E921478419A9@suse.de>
References: <ZV9ZSyDLNDlzutgQ@pharmakeia.incertum.net>
 <be371028-efeb-44af-90ea-5c307f27d4c6@leemhuis.info>
 <71576a9ff7398bfa4b8c0a1a1a2523383b056168.camel@gekmihesg.de>
 <989C39B9-A05D-4E4F-A842-A4943A29FFD6@suse.de>
 <1c2a1f362d667d36d83a5ba43218bad199855b11.camel@gekmihesg.de>
To: Markus Weippert <markus@gekmihesg.de>
X-Mailer: Apple Mail (2.3774.200.91.1.1)
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	none
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [-4.00 / 50.00];
	 REPLY(-4.00)[]
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 6E0E01FE7D



> 2023=E5=B9=B411=E6=9C=8824=E6=97=A5 21:55=EF=BC=8CMarkus Weippert =
<markus@gekmihesg.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Fri, 2023-11-24 at 21:46 +0800, Coly Li wrote:
>>=20
>>=20
>>> 2023=E5=B9=B411=E6=9C=8824=E6=97=A5 21:29=EF=BC=8CMarkus Weippert =
<markus@gekmihesg.de> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>>> On 23.11.23 14:53, Stefan F=C3=B6rster wrote:
>>>>>=20
>>>>> starting with kernel 6.1.39, we see the following error message
>>>>> with
>>>>> heavy I/O loads. We needed to revert
>>>>=20
>>>> Thx for the report. I assume that problem still occurs with the
>>>> latest
>>>> 6.1.y kernel?
>>>>=20
>>>>> =
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dv6.1.39&id=3D68118c339c6e1e16ae017bef160dbe28a27ae9c8
>>>>=20
>>>> FWIW, that is mainline commit 028ddcac477b69 ("bcache: Remove
>>>> unnecessary NULL point check in node allocations") [v6.5-rc1].
>>>>=20
>>>> Did a quick check and noticed a fix for that change was recently
>>>> mainlined as f72f4312d43883 ("bcache: replace a mistaken IS_ERR()
>>>> by
>>>> IS_ERR_OR_NULL() in btree_gc_coalesce()") [v6.7-rc2-post]:
>>>> https://lore.kernel.org/all/20231118163852.9692-1-colyli@suse.de/
>>>>=20
>>>> It is expected to soon be interegrated into a 6.1.y kernel.
>>>>=20
>>>> But maybe it's something else. I CCed the involved people, they
>>>> might
>>>> know.
>>>=20
>>> We applied f72f4312d43883 to the current Debian kernel (based on
>>> 6.1.55) but it didn't help, same stack trace.
>>> Looking at the description, __bch_btree_node_alloc() should never
>>> be
>>> able to return NULL anyway after
>>> =
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dv6.1.39&id=3D7ecea5ce3dc17339c280c75b58ac93d8c8620d9f
>>> But I didn't verify all callers, so this might still be correct, if
>>> it's not always initialized with the return value of
>>> __bch_btree_node_alloc().
>>>=20
>>> Anyway, I think we fixed it by applying this:
>>>=20
>>> diff -Naurp a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>>> --- a/drivers/md/bcache/btree.c 2023-09-23 11:11:13.000000000 +0200
>>> +++ b/drivers/md/bcache/btree.c 2023-11-24 13:13:09.840013759 +0100
>>> @@ -1489,7 +1489,7 @@ out_nocoalesce:
>>> bch_keylist_free(&keylist);
>>>=20
>>> for (i =3D 0; i < nodes; i++)
>>> - if (!IS_ERR(new_nodes[i])) {
>>> + if (!IS_ERR_OR_NULL(new_nodes[i])) {
>>> btree_node_free(new_nodes[i]);
>>> rw_unlock(true, new_nodes[i]);
>>> }
>>>=20
>>=20
>> The above change is what commit f72f4312d43883 ("bcache: replace a
>> mistaken IS_ERR() by IS_ERR_OR_NULL() in btree_gc_coalesce()=E2=80=9D =
does.
>=20
> But f72f4312d43883 reverts @@ -1340,7 +1340,7 @@, while the patch we
> applied reverts @@ -1487,7 +1487,7 @@ instead.
> Applying f72f4312d43883 didn't help for us.
>=20

OK, I know what you mean.  Yes, your fix is necessary too.

Would you like to post patch for your fix?

Thanks.

Coly Li


>>=20
>> Although the above patch is suggested to go into 6.5+ kernel, for
>> this condition it should go into all stable kernels where commit
>> 028ddcac477b69 ("bcache: Remove unnecessary NULL point check in node
>> allocations=E2=80=9D) were merged into.
[snipped]=

