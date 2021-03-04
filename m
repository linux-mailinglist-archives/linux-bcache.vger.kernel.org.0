Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314C632DA5C
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Mar 2021 20:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbhCDT0n (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 4 Mar 2021 14:26:43 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58053 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233750AbhCDT0a (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 Mar 2021 14:26:30 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id ADA715C00D7
        for <linux-bcache@vger.kernel.org>; Thu,  4 Mar 2021 14:25:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Thu, 04 Mar 2021 14:25:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s4y.us; h=from
        :content-type:content-transfer-encoding:mime-version:subject
        :message-id:date:to; s=fm2; bh=fTgxpna9ZXxO2uK2ciptfV6IfmNCSEC4V
        FGKdrM27zo=; b=xQfuf1gi6hCPhaS+BD8QeWMRDQrr/Cq1Pfr/HGNcB5aDVgASB
        2U27dnC6RH0qxDjNy1MbZpqAfGBA6qKYrpMsJgOX3aPnnsnpSqk6LgCcLMnQmFQs
        AuxO3b+N5blKTIxaYKDAWkWWdmk4896rhKLNkRkEveOTHTSP91Xs5ltXDIQ2feqw
        G7dkq1x+OIifRxa5SFNwKLGxh5z8xJHy0HVcc6FW1LGeVPcdN/por/tk3+1Yn4dQ
        O4gpPJHU8BgFycU2PYdPiWbCdMdk4nzH6RX8+XRXfykKDZGL86U9Sz/EMmtvSXYF
        zdUGhsw0aFTmbqvwZPoDuwnB5Lms4bZUlQHvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fTgxpn
        a9ZXxO2uK2ciptfV6IfmNCSEC4VFGKdrM27zo=; b=l/uf8E4zW6+6bymkX06saU
        rGzf2GnyI3T5xIg9ua84Q6lIRtS5mOEDqMtEVzforhSvrt5n5YczsRbBHU4TD3aq
        joEjUBNOVN1G9nVBGEJVveWY+iq9qw40YwjocruLKDoUfyKS5Wr/Vb1A11pewYMB
        w1EDLJRBGwlVcFfSIxfcSVSlvnT3sGtmZv7Xn8X0CI4fvsR+E+TJLdRreGsDqO1x
        v0k1lAiK0hbhA1AVnCbzSaD033g7lEucEyYA3qspxT9JMkTElc9Wur1h0JC6OJP/
        N3DaUkBdAu7mHH12SHMMiDDwLvST3Qk7BkRl/m3FTu2pGZoFJFkwFJPwGlRH3TQw
        ==
X-ME-Sender: <xms:JDRBYCAXWlNX5Hq4J9EuYyXd7aJrWS_2UH52vK_eWlR12J39JEO_dw>
    <xme:JDRBYMi0mMeh4mrS0Ch9xc_UFS101BviiHn-MX3oKhcpvF43HxXxeH9rlEzu39BWj
    _rvjfaP9x68DUTub2M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephfgtgfgguffkfffvofesthhqmh
    dthhdtjeenucfhrhhomhepufhiughnvgihpgfurghnpgforghrthovnhcuoehsihgunhgv
    hiessheghidruhhsqeenucggtffrrghtthgvrhhnpeetheetudeltddutdekgfegieehfe
    evtdetuddvfefgieettddugfevleelieeltdenucffohhmrghinhepshhpihhnihgtshdr
    nhgvthdpkhgvrhhnvghlrdhorhhgnecukfhppeejvddrvdefuddrtddrudegvdenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsihgunhgvhies
    sheghidruhhs
X-ME-Proxy: <xmx:JDRBYFkBMT5qYDOb7rCirqfvxzXEaN6ES0gad36za8HG5m7yZgZ77g>
    <xmx:JDRBYAz1AjMOuOt7STzaQus_dn60C_J4GPkx1GWUcvgng9OoX22_TA>
    <xmx:JDRBYHTivuvMOAT5B0tcyAnNSQ5J5TEmZfymtsE6yAGIk7W-r8kS7w>
    <xmx:JDRBYOdF6nY8PpjNyL8eI69LlEgDbuTGYpC45k6cKUU2T86JhXezIw>
Received: from s4y.s4y.us (cpe-72-231-0-142.nyc.res.rr.com [72.231.0.142])
        by mail.messagingengine.com (Postfix) with ESMTPA id 61326108005C
        for <linux-bcache@vger.kernel.org>; Thu,  4 Mar 2021 14:25:24 -0500 (EST)
From:   =?utf-8?Q?Sidney_San_Mart=C3=ADn?= <sidney@s4y.us>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Can't mount filesystem after clean shutdown with discard enabled
Message-Id: <06080D15-33CA-4CB8-9FF9-F6D0222E839E@s4y.us>
Date:   Thu, 4 Mar 2021 14:25:23 -0500
To:     linux-bcache@vger.kernel.org
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I enabled discard on the bcache backing a large filesystem with =
writeback caching a few weeks ago. Yesterday I restarted the system =
cleanly and it failed to come back. I see the following in the log:

  Mar 04 19:04:18 archiso kernel: bcache: prio_read() bad csum reading =
priorities
  Mar 04 19:04:18 archiso kernel: bcache: bch_cache_set_error() error on =
6432e656-f28e-49f8-943d-6307d42d37e9: IO error reading priorities, =
disabling caching

The backing devices are all marked dirty when I check with =
bcache-super-show. I see threads going back years mentioning this =
problem:

  https://www.spinics.net/lists/linux-bcache/msg02712.html
  https://www.spinics.net/lists/linux-bcache/msg02954.html
  https://www.spinics.net/lists/linux-bcache/msg04668.html
  https://www.spinics.net/lists/linux-bcache/msg05279.html

There is also a bug report: =
https://bugzilla.kernel.org/show_bug.cgi?id=3D197377

The cache device backs a large BTRFS volume made up of many spinning =
disks and, while I have a backup, it=E2=80=99s offsite and will take a =
huge amount of time to restore. Since I=E2=80=99m running BTRFS with =
some redundancy, I would love to do whatever I can to get things back to =
as good a state as possible and try a scrub.

I tried building bcache myself and skipping loading priorities, since =
comments suggest they=E2=80=99re nonessential, and the next thing I hit =
is:

  Mar 04 15:32:56 archiso kernel: bcache: bch_cache_set_error() error on =
6432e656-f28e-49f8-943d-6307d42d37e9: unsupported bset version at bucket =
108857, block 0, 79054670 keys, disabling caching

Note that I=E2=80=99m not familiar with bcache internals and this is =
actually my first time building a kernel module to debug something.

What can I do here? And should discard even be available as an option if =
it fails this badly?=
