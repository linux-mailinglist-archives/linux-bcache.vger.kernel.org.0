Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBE03488DD
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Mar 2021 07:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCYGRI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 25 Mar 2021 02:17:08 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:32861 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229448AbhCYGQj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Mar 2021 02:16:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id D70EFD65;
        Thu, 25 Mar 2021 02:16:38 -0400 (EDT)
Received: from imap7 ([10.202.2.57])
  by compute4.internal (MEProxy); Thu, 25 Mar 2021 02:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rath.org; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type:content-transfer-encoding; s=fm2; bh=hJ315
        BfD2C941HREUIXbFU/WbgYlTdSd8UmqeyMTKeY=; b=j1RrahxTv61Yk9AEkbCm0
        Su4C1zQir2lxqHBmtTjZwCUOZojfyMNL6z0iI9ExZ74gy/w84KdRduUkddgTSn/S
        MyvGf7YHQ03G4xYvSRuZ7FWK8YMflQanvamEdiDnoKaW3v+wVT2xM7U9wo+ZXlOL
        1xdm8H/keFyv1BYYiyMCmgYg8J/19Av9bxdXSJZB/L6kTKC+zmyGDklC90yn/x09
        9ZBvCzMJGGdueEOhaUwKCQxAAmAwHntX5YW90OLq/NceCO6n7NZr+X2Jbu1XX1om
        CDr82y732FVei3mQz+3+3YBoBjdj5og82BjDOvX6J+VVyznk94OltZ0rJiZVVftx
        A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=hJ315BfD2C941HREUIXbFU/WbgYlTdSd8UmqeyMTK
        eY=; b=fIu9Xa7jCpqkgtKoD9vvDqGP17+JqzrxJAMXtCQ8gUBonTH+vkmIKItDf
        OSyl55ESDHOyIwfkl9GAgN7u60gxuiVwQFwvca6nn6KwsbTZ1bcmvdRRcJDJWqYU
        f+ynSklnbp1NpbP/8+Exlg8I+7AvpuRlkYnAfA1YJG44SzQTmJM/MhNYAkUtTfoV
        YDBWhP4e7x7CtzQuLLx9BpAiYIb/z6Z0Z1FM5NAYFTkL2UuO/adZ16UbBpmeBN6A
        wf03SDkg4XheZ9j/3F/wxrJ+hsVVZITW2QjSB6CvRLH81bpVhkgab3RSyOPzDW6H
        J44F3acuugBsL+4jvWz0Z+F2j6q+Q==
X-ME-Sender: <xms:xipcYEmrZEug_edXaFKyuTJ3Y2Q3CT5gWaNiGIMx7wIJwzTi0E_dhg>
    <xme:xipcYD2gAgkbjdat1MTU1Y3mmNEG43Ee9eMG8wH6hLObDfSO7cBjQ0SZbL7F16nTv
    T2rCx9WSfQ7kSxa>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhushhpvggtthffohhmrghinhculdegledmnecujfgurhepofgfggfkjghffffhvffu
    tgfgsehtqhertderreejnecuhfhrohhmpedfpfhikhholhgruhhsucftrghthhdfuceonh
    hikhholhgruhhssehrrghthhdrohhrgheqnecuggftrfgrthhtvghrnhepudejjeejteeg
    jeegfeejkeffuddvhfdvleeffeejfeffleelteeiueekhfefudefnecuffhomhgrihhnpe
    hgohhoghhlvgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehnihhkohhlrghushesrhgrthhhrdhorhhg
X-ME-Proxy: <xmx:xipcYCpgscd2-svR8KA5yXcIpF9G2DTrjKmowhtzN4pdQuNFOWDFCQ>
    <xmx:xipcYAkah7oOMAaVLAOGCBATpvKfeXLV76SsyiOVimkNxPejdgsBLg>
    <xmx:xipcYC3wede2WN7oqPcLKZUJPSHDOgzzcgpByRVwmaRRQCuzRz1A5Q>
    <xmx:xipcYAD2L-ntw3pAIiBy9rwtUzMYCBJSHrlV3aTatyLrNMh_VnBgFw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 2B20836005F; Thu, 25 Mar 2021 02:16:38 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-273-g8500d2492d-fm-20210323.002-g8500d249
Mime-Version: 1.0
Message-Id: <397bddb7-9750-4dd9-bf6e-2287d89778f1@www.fastmail.com>
In-Reply-To: <bcfeb53d-b8b0-883a-7a02-90b44b23f4dd@suse.de>
References: <3030cad3-47e2-43b0-8a82-656c6b774c78@www.fastmail.com>
 <bcfeb53d-b8b0-883a-7a02-90b44b23f4dd@suse.de>
Date:   Thu, 25 Mar 2021 06:16:17 +0000
From:   "Nikolaus Rath" <nikolaus@rath.org>
To:     "Coly Li" <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: Undoing an "Auto-Stop" when Cache device has recovered?
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Thu, 25 Mar 2021, at 05:29, Coly Li wrote:
> On 3/25/21 4:21 AM, Nikolaus Rath wrote:
> > Hello,
> >=20
> > My (writeback enabled) bcache cache device had a temporary failure, =
but seems to have fully recovered (it may have been overheating or a loo=
se cable).
> >=20
> > From the last kernel messages, it seems that bcache tried to flush t=
he dirty data, but failed, and then stopped the cache device.
> >=20
> > After a reboot, the bcacheX device indeed no longer has an associate=
d cache set..
> >=20
> > I think in my case the cache device is in perfect shape again and st=
ill has all the data, so I would really like bcache to attach it again s=
o that the dirty cache data is not lost.
> >=20
> > Is there a way to do that?
> >=20
> > (Yes, I will still replace the device afterwards)
> >=20
> > (I am pretty sure that just re-attaching the cacheset will make bcac=
he forget that there was a previous association and will wipe the corres=
ponding metadata).
> >=20
>=20
> Hi Nikolaus,
>=20
> Do you have the kernel log? It depends on whether the cache set is cle=
an
> or not. For a clear cache set, the cache set is detached, and next
> reattach will invalidate all existing cached data. If the cache set is=

> dirty and all existing data is wiped, that will be fishy....

Hi Cody,

I'm not sure I understand. I believe there is dirty data on the cacheset=
 (it was effectively disconnected in the middle of operations). Also, if=
 it wasn't dirty then there would be no need to re-attach it (all the im=
portant data would be on the backing device).

On the other hand, after a reboot the cache set shows up in /sys/fs/bcac=
he - just not associated with any backing device. So I guess from that p=
oint of view it is clean?

The kernel logs are on the affected bcache, and I have avoided doing any=
thing with it (including mounting). I took a few pictures of the last vi=
sible messages on the console before re-booting though. For example, her=
e is when the problem starts

First ATA errors: https://drive.google.com/file/d/1_vr-JBWZjajzbWyXUSmtn=
4faNH6072ut/view?usp=3Dsharing
First bcache errors: https://drive.google.com/file/d/1XLCWDi6G2lP1JiVitZ=
TtIqzB4QqxXv2-/view?usp=3Dsharing

Does that help?

Best,
-Nikolaus

--
GPG Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             =C2=BBTime flies like an arrow, fruit flies like a Banana.=C2=
=AB
