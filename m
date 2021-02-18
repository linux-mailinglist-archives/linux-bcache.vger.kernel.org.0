Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F6431F24A
	for <lists+linux-bcache@lfdr.de>; Thu, 18 Feb 2021 23:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhBRW0a (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 18 Feb 2021 17:26:30 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:59918 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhBRW03 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 18 Feb 2021 17:26:29 -0500
X-Greylist: delayed 3849 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Feb 2021 17:26:28 EST
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTP id 11ILL1KD017223;
        Thu, 18 Feb 2021 21:21:01 GMT
From:   Nix <nix@esperi.org.uk>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: Re: [PATCH 17/20] bcache: support storing bcache journal into NVDIMM meta device
References: <20210210050742.31237-1-colyli@suse.de>
        <20210210050742.31237-18-colyli@suse.de>
Emacs:  ballast for RAM.
Date:   Thu, 18 Feb 2021 21:21:00 +0000
In-Reply-To: <20210210050742.31237-18-colyli@suse.de> (Coly Li's message of
        "Wed, 10 Feb 2021 13:07:39 +0800")
Message-ID: <87k0r5ysw3.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1102; Body=6 Fuz1=6 Fuz2=6
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10 Feb 2021, Coly Li uttered the following:

> This patch implements two methods to store bcache journal to,
> 1) __journal_write_unlocked() for block interface device
>    The latency method to compose bio and issue the jset bio to cache

Is this really 'latency'? I suspect from other patches it should be
'legacy', which is surely not true unless the expectation is that soon
all bcache users will have NVDIMMs and can use the other path (surely
not).

> For lagency

This non-word should possibly be 'legacy' too?
