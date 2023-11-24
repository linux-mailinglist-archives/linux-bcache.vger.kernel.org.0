Return-Path: <linux-bcache+bounces-34-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9561D7F7996
	for <lists+linux-bcache@lfdr.de>; Fri, 24 Nov 2023 17:42:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6B6A1C20935
	for <lists+linux-bcache@lfdr.de>; Fri, 24 Nov 2023 16:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E34431754;
	Fri, 24 Nov 2023 16:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04653199A;
	Fri, 24 Nov 2023 08:42:44 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 72B201FDF6;
	Fri, 24 Nov 2023 16:42:42 +0000 (UTC)
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id EDA38132E2;
	Fri, 24 Nov 2023 16:42:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id rLxzJ37SYGU5SQAAn2gu4w
	(envelope-from <colyli@suse.de>); Fri, 24 Nov 2023 16:42:38 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.200.91.1.1\))
Subject: Re: [PATCH] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR
From: Coly Li <colyli@suse.de>
In-Reply-To: <11a7d768-c6e7-4a6e-875d-87858bf023a5@kernel.dk>
Date: Sat, 25 Nov 2023 00:42:21 +0800
Cc: Markus Weippert <markus@gekmihesg.de>,
 Bcache Linux <linux-bcache@vger.kernel.org>,
 Thorsten Leemhuis <regressions@leemhuis.info>,
 Zheng Wang <zyytlz.wz@163.com>,
 linux-kernel@vger.kernel.org,
 =?utf-8?Q?Stefan_F=C3=B6rster?= <cite@incertum.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Linux kernel regressions list <regressions@lists.linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <640974BB-8D2A-4B64-B8F6-C59E931DDFE4@suse.de>
References: <ZV9ZSyDLNDlzutgQ@pharmakeia.incertum.net>
 <be371028-efeb-44af-90ea-5c307f27d4c6@leemhuis.info>
 <71576a9ff7398bfa4b8c0a1a1a2523383b056168.camel@gekmihesg.de>
 <989C39B9-A05D-4E4F-A842-A4943A29FFD6@suse.de>
 <1c2a1f362d667d36d83a5ba43218bad199855b11.camel@gekmihesg.de>
 <3DF4A87A-2AC1-4893-AE5F-E921478419A9@suse.de>
 <c47d3540ece151a2fb30e1c7b5881cb8922db915.camel@gekmihesg.de>
 <B68E455A-D6EB-4BB9-BD60-F2F8C3C8C21A@suse.de>
 <54706535-208b-43b5-814f-570ffa7b29bb@kernel.dk>
 <910112B4-168D-4ECC-B374-7E6668B778F9@suse.de>
 <11a7d768-c6e7-4a6e-875d-87858bf023a5@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3774.200.91.1.1)
X-Spamd-Bar: +++++++++++++
Authentication-Results: smtp-out2.suse.de;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=suse.de (policy=none);
	spf=softfail (smtp-out2.suse.de: 2a07:de40:b281:104:10:150:64:98 is neither permitted nor denied by domain of colyli@suse.de) smtp.mailfrom=colyli@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [13.70 / 50.00];
	 ARC_NA(0.00)[];
	 TO_DN_EQ_ADDR_SOME(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 MV_CASE(0.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 FREEMAIL_ENVRCPT(0.00)[163.com];
	 R_SPF_SOFTFAIL(4.60)[~all:c];
	 BAYES_HAM(-0.09)[64.76%];
	 RCVD_COUNT_THREE(0.00)[3];
	 NEURAL_SPAM_SHORT(3.00)[1.000];
	 MX_GOOD(-0.01)[];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 RCPT_COUNT_SEVEN(0.00)[10];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,gekmihesg.de:email,kernel.dk:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[gekmihesg.de,vger.kernel.org,leemhuis.info,163.com,incertum.net,linuxfoundation.org,lists.linux.dev];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 DMARC_POLICY_SOFTFAIL(0.10)[suse.de : No valid SPF, No valid DKIM,none]
X-Spam-Score: 13.70
X-Rspamd-Queue-Id: 72B201FDF6



> 2023=E5=B9=B411=E6=9C=8825=E6=97=A5 00:35=EF=BC=8CJens Axboe =
<axboe@kernel.dk> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 11/24/23 9:34 AM, Coly Li wrote:
>>=20
>>=20
>>> 2023?11?25? 00:31?Jens Axboe <axboe@kernel.dk> ???
>>>=20
>>> On 11/24/23 9:29 AM, Coly Li wrote:
>>>>=20
>>>>=20
>>>>> 2023?11?24? 23:14?Markus Weippert <markus@gekmihesg.de> ???
>>>>>=20
>>>>> Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check =
in
>>>>> node allocations") replaced IS_ERR_OR_NULL by IS_ERR. This leads =
to a
>>>>> NULL pointer dereference.
>>>>>=20
>>>>> BUG: kernel NULL pointer dereference, address: 0000000000000080
>>>>> Call Trace:
>>>>> ? __die_body.cold+0x1a/0x1f
>>>>> ? page_fault_oops+0xd2/0x2b0
>>>>> ? exc_page_fault+0x70/0x170
>>>>> ? asm_exc_page_fault+0x22/0x30
>>>>> ? btree_node_free+0xf/0x160 [bcache]
>>>>> ? up_write+0x32/0x60
>>>>> btree_gc_coalesce+0x2aa/0x890 [bcache]
>>>>> ? bch_extent_bad+0x70/0x170 [bcache]
>>>>> btree_gc_recurse+0x130/0x390 [bcache]
>>>>> ? btree_gc_mark_node+0x72/0x230 [bcache]
>>>>> bch_btree_gc+0x5da/0x600 [bcache]
>>>>> ? cpuusage_read+0x10/0x10
>>>>> ? bch_btree_gc+0x600/0x600 [bcache]
>>>>> bch_gc_thread+0x135/0x180 [bcache]
>>>>>=20
>>>>> The relevant code starts with:
>>>>>=20
>>>>>  new_nodes[0] =3D NULL;
>>>>>=20
>>>>>  for (i =3D 0; i < nodes; i++) {
>>>>>      if (__bch_keylist_realloc(&keylist, bkey_u64s(&r[i].b->key)))
>>>>>          goto out_nocoalesce;
>>>>>  // ...
>>>>> out_nocoalesce:
>>>>>  // ...
>>>>>  for (i =3D 0; i < nodes; i++)
>>>>>      if (!IS_ERR(new_nodes[i])) {  // IS_ERR_OR_NULL before
>>>>> 028ddcac477b
>>>>>          btree_node_free(new_nodes[i]);  // new_nodes[0] is NULL
>>>>>          rw_unlock(true, new_nodes[i]);
>>>>>      }
>>>>>=20
>>>>> This patch replaces IS_ERR() by IS_ERR_OR_NULL() to fix this.
>>>>>=20
>>>>> Fixes: 028ddcac477b ("bcache: Remove unnecessary NULL point check =
in
>>>>> node allocations")
>>>>> Link:
>>>>> =
https://lore.kernel.org/all/3DF4A87A-2AC1-4893-AE5F-E921478419A9@suse.de/
>>>>> Cc: stable@vger.kernel.org
>>>>> Cc: Zheng Wang <zyytlz.wz@163.com>
>>>>> Cc: Coly Li <colyli@suse.de>
>>>>> Signed-off-by: Markus Weippert <markus@gekmihesg.de>
>>>>=20
>>>> Added into my for-next.  Thanks for patching up.
>>>=20
>>> We should probably get this into the current release, rather than =
punt
>>> it to 6.8.
>>=20
>> Yes, copied. So far I don?t have other bcache patches for 6.7, I feel
>> I might be redundant if I send you another for -rc4 series with this
>> single patch.
>>=20
>> Could you please directly take it into -rc4?
>=20
> Sure, I'll just grab it as-is.

Thanks for doing this.

Coly Li


