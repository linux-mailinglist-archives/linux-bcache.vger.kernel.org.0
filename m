Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27864AB66B
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Feb 2022 09:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiBGIQi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Feb 2022 03:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241585AbiBGIK0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Feb 2022 03:10:26 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B19C043184
        for <linux-bcache@vger.kernel.org>; Mon,  7 Feb 2022 00:10:25 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id m6so37485350ybc.9
        for <linux-bcache@vger.kernel.org>; Mon, 07 Feb 2022 00:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y8KKV2330hEh9wQOvdHW9wi2cK5yOCifVXe6xnFujyg=;
        b=JzTm+0Wd7YjVQHxpA/6WjnQkTcu3hYkIPROyuxgO+ssKhcwo9Itx223WptAlwFT0n1
         0hNYcKf9N/2F9NIzp4BktE2HLJyKtCir5WSvIzT0TBaIg/79pzJ13GR+wghldBE7iJBe
         uOXJfuvzI8Ou0ba32oog44RRXpGQS3D4+9E80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y8KKV2330hEh9wQOvdHW9wi2cK5yOCifVXe6xnFujyg=;
        b=lTeKogSx1yVXwnM5hzoxuPVx16TEKCvlKXNmROt93h4jRgREszg0dAs3rNbkjKN4l4
         EmQ1unDPbfdA02/YdBuasU5RYROKR2SGwDo7Bvd/E9QEfTB17jJzD4qM4wzstiKNoRW6
         GzPyV5w78843p9PlBGBUMJeUxeRptEU957TYqX6zbdHmK+PedPQtw2e9mTXvF7ygubCW
         A2UH1921qBWON2Svb/RNDMnt9fUuJGfgMc2J4pp4laq9r8JKFpkrgpKn5DF3DKaUt/oz
         bdC1kjT0jTAZikTQh98aE3N3nHljlUOZhXb7vAKZgPp3X0re0AO/vQnpoVEDp0agseXk
         hyhQ==
X-Gm-Message-State: AOAM530y5d1lPjRQfplAuz4aZyHZ7CsYWpqsE+J/UubnHuJu4Z+tBwUV
        i41T4ujFGkVj+XyvT4J4m1WQwu+CYVgVOU9NbXdSnzVg5e1SgA==
X-Google-Smtp-Source: ABdhPJy5QXBvqxK3kRg/2Y4sBNGBeMjZX2YcCDkDHzVj8XQESgJD4jxsHs8l9MxDwLTdltsyQDHj7/+rbTI9j1xAKag=
X-Received: by 2002:a5b:1cf:: with SMTP id f15mr9214528ybp.341.1644221424768;
 Mon, 07 Feb 2022 00:10:24 -0800 (PST)
MIME-Version: 1.0
References: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com>
 <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de> <CAC2ZOYsoZJ2_73ZBfN13txs0=zqMVcjqDMMjmiWCq=kE8sprcw@mail.gmail.com>
 <688136f0-78a9-cf1f-cc68-928c4316c81b@bcache.ewheeler.net>
 <8e25f190-c712-0244-3bfd-65f1d7c7df33@suse.de> <431f7be3-3b72-110-692c-ca8a11265d3@ewheeler.net>
 <8799ba1c-5c12-d69b-948f-4df9667a801a@suse.de> <c9ebe2b9-d896-4f6e-ecf9-504bd98abe76@suse.de>
 <9f31c511-3898-8ab2-d695-3ae000c7fe99@suse.de>
In-Reply-To: <9f31c511-3898-8ab2-d695-3ae000c7fe99@suse.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Mon, 7 Feb 2022 09:10:14 +0100
Message-ID: <CAC2ZOYsHY=7-zJ8WApgC6rhaMyFLp+-=83hD1pdzB2xBrSEfUg@mail.gmail.com>
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org,
        =?UTF-8?B?RnLDqWTDqXJpYyBEdW1hcw==?= <f.dumas@ellis.siteparc.fr>,
        Kent Overstreet <kent.overstreet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Am Mo., 7. Feb. 2022 um 08:37 Uhr schrieb Coly Li <colyli@suse.de>:

> For the problem reported by Kai in this thread, the dmesg
>
> [   27.334306] bcache: bch_cache_set_error() error on
> 04af889c-4ccb-401b-b525-fb9613a81b69: empty set at bucket 1213, block
> 1, 0 keys, disabling caching
> [   27.334453] bcache: cache_set_free() Cache set
> 04af889c-4ccb-401b-b525-fb9613a81b69 unregistered
> [   27.334510] bcache: register_cache() error sda3: failed to run cache s=
et
> [   27.334512] bcache: register_bcache() error : failed to register devic=
e
>
> tells that the mate data is corrupted which probably by uncompleted meta =
data write, which some other people and I countered too (some specific bcac=
he block size on specific device). Update to latest stable kernel may solve=
 the issue, but I don't verify whether the regression is fixed or not.

As far as I can tell, the problem hasn't happened again since. I think
I saw the problem in 5.15.2 (the first 5.15.x I tried), and it was
fixed probably by 'bcache: Revert "bcache: use bvec_virt"' in 5.15.3.
I even tried write-back mode again on multiple systems and it is
stable. OTOH, I must say that I only enabled writeback caching after
using btrfs metadata hinting patches which can move metadata to native
SSD devices - so bcache will no longer handle btrfs metadata writes or
reads. Performance-wise, this seems a superior setup, even bcache
seems to struggle with btrfs metadata access patterns. But I doubt it
has anything to do with whether the 5.15.2 problem triggers or
doesn't, just wanted to state that for completeness.

Regards,
Kai
