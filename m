Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98CD3117CFB
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Dec 2019 02:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbfLJBPO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 20:15:14 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:56001 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbfLJBPJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 20:15:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 817C0A0633;
        Tue, 10 Dec 2019 01:15:08 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id HxpQSZ9ambHf; Tue, 10 Dec 2019 01:14:47 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 1B253A0440;
        Tue, 10 Dec 2019 01:14:47 +0000 (UTC)
Date:   Tue, 10 Dec 2019 01:14:46 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Nathan Dehnel <ncdehnel@gmail.com>
cc:     linux-bcache@vger.kernel.org
Subject: Re: Trying to attach a cache drive gives "invalid argument"
In-Reply-To: <CAEEhgEsy8+aZuEfw5vX_ytKhCq2WxnC=N6AS0msKx_JgJb+=-g@mail.gmail.com>
Message-ID: <alpine.LRH.2.11.1912100111590.11561@mx.ewheeler.net>
References: <CAEEhgEtXKoQymHyS278GvE=95jNiW71sb1bz_-2AfOkDPp0dMw@mail.gmail.com> <alpine.LRH.2.11.1912100029180.11561@mx.ewheeler.net> <CAEEhgEsy8+aZuEfw5vX_ytKhCq2WxnC=N6AS0msKx_JgJb+=-g@mail.gmail.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, 9 Dec 2019, Nathan Dehnel wrote:

> [ 9651.101227] bcache: bch_cached_dev_attach() Couldn't attach sda1:
> block size less than set's block size

What do these report:

blockdev --report /dev/bcache0
blockdev --report /dev/sdX     # bcache cache dev
blockdev --report /dev/sdY     # bcache bdev


bcache-super-show /dev/sdX # bcache cache dev
bcache-super-show /dev/sdY # bcache bdev

--
Eric Wheeler

> 
> On Mon, Dec 9, 2019 at 6:30 PM Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> >
> > On Mon, 9 Dec 2019, Nathan Dehnel wrote:
> >
> > > root@gentooserver / # echo 45511b33-6bb8-42d5-a255-3de1749f8dda >
> > > /sys/block/bcache0/bcache/attach
> > > -bash: echo: write error: Invalid argument
> >
> > What does `dmesg` say?
> >
> >
> > --
> > Eric Wheeler
> >
> >
> >
> > >
> > > How should I fix this?
> > >
> 
