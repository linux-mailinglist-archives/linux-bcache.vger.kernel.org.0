Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF3A612F3C
	for <lists+linux-bcache@lfdr.de>; Mon, 31 Oct 2022 04:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJaDKZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 30 Oct 2022 23:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaDKY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 30 Oct 2022 23:10:24 -0400
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59A99582
        for <linux-bcache@vger.kernel.org>; Sun, 30 Oct 2022 20:10:22 -0700 (PDT)
Date:   Mon, 31 Oct 2022 04:10:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=t-8ch.de; s=mail;
        t=1667185820; bh=/pQg/IjUKHqVJH9bxaRci8NQT9eKgH49pC7lMcqIuUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m9iNb07Wibudj/x0Ipoh9mFMCm/eNqBx/4nrVvlC++ZpzCZHFakvd3S9RsqMqTm7T
         mkp2mz6SRo9Xma/mJaIvqsERhC0cv22A13fSJ7w8Tx7XqvYhUq79oMgeiEluHaE1GL
         xtpZpImW3WDKeHKpMZVa/PSZDbFa4qenLimMKW/A=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs-tools: O_DIRECT necessary?
Message-ID: <bb3fa56a-7fa2-4920-98a2-6768845ef6cd@t-8ch.de>
References: <b82ce4e9-7f8f-4f67-a6b9-09dc90ccd49c@t-8ch.de>
 <20221031014000.hgohrfv7t4dpraia@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221031014000.hgohrfv7t4dpraia@moria.home.lan>
Jabber-ID: thomas@t-8ch.de
X-Accept: text/plain, text/html;q=0.2, text/*;q=0.1
X-Accept-Language: en-us, en;q=0.8, de-de;q=0.7, de;q=0.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2022-10-30 21:41-0400, Kent Overstreet wrote:
> On Mon, Oct 31, 2022 at 02:18:40AM +0100, Thomas Weißschuh wrote:
> > Hi all,
> > 
> > I just tried to run the unittests of bcachefs-tools and they are failing for
> > me.
> > The culprit is that mkfs.bcachefs tries to open the disk image with O_DIRECT
> > which is not allowed on tmpfs.
> > 
> > Is O_DIRECT really necessary for mkfs? It does not seem necessary for other
> > filesystems.
> 
> Hey - the proper mailing list for bcachefs is linux-bcachefs@vger.kernel.org now
> :)

My bad, I copied the wrong list from one of your mails.

> It's not strictly necessary, we use O_DIRECT because we're emulating the kernel
> bio interface. There are other situations where this has been a problem though,
> we need to add either a flag to use buffered IO or preferably a way to
> automatically fall back to buffered IO.
> 
> Could you open a bug for this? I'll try to get to it in the near future
> 
> https://github.com/koverstreet/bcachefs/issues/

I opened it in the tools repo because those are broken:
https://github.com/koverstreet/bcachefs-tools/issues/132

Thomas
