Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97AC3482C8
	for <lists+linux-bcache@lfdr.de>; Wed, 24 Mar 2021 21:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238097AbhCXUWM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 24 Mar 2021 16:22:12 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:33555 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237807AbhCXUVl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Mar 2021 16:21:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 58F7CA18
        for <linux-bcache@vger.kernel.org>; Wed, 24 Mar 2021 16:21:41 -0400 (EDT)
Received: from imap7 ([10.202.2.57])
  by compute4.internal (MEProxy); Wed, 24 Mar 2021 16:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rath.org; h=
        mime-version:message-id:date:from:to:subject:content-type
        :content-transfer-encoding; s=fm2; bh=wV4YJ5VwDwfNfGAZNlCyIFttF3
        gpBUamRPNRIPV27Pg=; b=NgIT/jNXUCHzJTCzIkJNa1gRGL8Wl6hDPHaCRPG0O+
        nSd3f0t/ZdU4exRCbuS+Gxf+Bl6fUHymfVe03s00Zafb9It7uZa+oY7zkknxGPad
        LpndxCOTMe6U9rwN3zf+8hxepMPEUEYdSPaisu/3eUDyhwOp5XdnEiSQ2xw1/nog
        wm3/oeolHAxCue2WatEPvbKNR7mUU/H3KESKM8C9ZcNfJM+pJJSl6jOd3qrMjfDz
        i/imkwU9fvLTuy2f+DeICpy8oirbmiCpot7fSuB3s4aLhz8QbShSanj+awDbzwT1
        IFvfqLSEOJCveeuvqpQJenVSIP/eBzmqiHybDVlhNhMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wV4YJ5
        VwDwfNfGAZNlCyIFttF3gpBUamRPNRIPV27Pg=; b=K6pZtp1wMyTUnyeAECOnkm
        y1VpqWuUvySRVBXm4g8xHBK0K5MTobXf/A1JYGKvrzKZDD93g6crbIsIN23n/yMX
        x9FDM9L36HyjY5D/P5imJMGaqU/Y2CLsfa++5VqmS3M6guoUPW/bofh2MDCCu/9a
        o0ajxnU/cF6GpzVZ4J4y8wa8qS8lMIs0EAwvYGzjg60lIWmIE9lb5ih0UmPUWUks
        sVNm3rUF7gI2IY3OmFoU1+OgbEToh24fT19qzCQ1mfu6UhsPCej0Z0/YPEzjFwaX
        FYrZYJpYqOZa7qDu9l7Q+eu1zEP+eTxo1IWcl/SCzv9JmRTwglW5ozrIkjgJRTaw
        ==
X-ME-Sender: <xms:VJ9bYAADn815nIFlRwoeAWXw42GgR03Tuz1E4g8t6WMaVTZJOoU_jQ>
    <xme:VJ9bYChjXHVPpksH93VT5EUEryZTqBO_S6k_VP3r6sf6OPnBGfoIaaW6r4H9hWPi_
    vhuH67IJpP-NTB2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepofgfggfkfffhvffutgfgsehtqh
    ertderreejnecuhfhrohhmpedfpfhikhholhgruhhsucftrghthhdfuceonhhikhholhgr
    uhhssehrrghthhdrohhrgheqnecuggftrfgrthhtvghrnhepffffkeetueegteeifeeutd
    efieehvedvueevhfekueffgfetteduhfegvefgffeunecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepnhhikhholhgruhhssehrrghthhdrohhrgh
X-ME-Proxy: <xmx:VJ9bYDmArAmR3YjzdsrOWdobGqTIraI-o6znykLEuuoO5N1SYCNeCQ>
    <xmx:VJ9bYGw6FQFA3V-u6VPdVZDLtFQloVEincpXL7-HDqo6_rkAV2g8PQ>
    <xmx:VJ9bYFSsWkh0XjajP4pPuXLjCE2lSAYFlDC5KMMqVqYK_eOR61Yb1w>
    <xmx:VJ9bYEKn-PPf-MEOwF1HaO3PY9maK9DJXKbHEE4Pq4NYMaHUnEqlvA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 7E5DA36005F; Wed, 24 Mar 2021 16:21:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-273-g8500d2492d-fm-20210323.002-g8500d249
Mime-Version: 1.0
Message-Id: <3030cad3-47e2-43b0-8a82-656c6b774c78@www.fastmail.com>
Date:   Wed, 24 Mar 2021 20:21:20 +0000
From:   "Nikolaus Rath" <nikolaus@rath.org>
To:     linux-bcache@vger.kernel.org
Subject: Undoing an "Auto-Stop" when Cache device has recovered?
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

My (writeback enabled) bcache cache device had a temporary failure, but =
seems to have fully recovered (it may have been overheating or a loose c=
able).

From the last kernel messages, it seems that bcache tried to flush the d=
irty data, but failed, and then stopped the cache device.

After a reboot, the bcacheX device indeed no longer has an associated ca=
che set..

I think in my case the cache device is in perfect shape again and still =
has all the data, so I would really like bcache to attach it again so th=
at the dirty cache data is not lost.

Is there a way to do that?

(Yes, I will still replace the device afterwards)

(I am pretty sure that just re-attaching the cacheset will make bcache f=
orget that there was a previous association and will wipe the correspond=
ing metadata).

Best,
Nikolaus

--
GPG Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             =C2=BBTime flies like an arrow, fruit flies like a Banana.=C2=
=AB

