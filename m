Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A531E214B44
	for <lists+linux-bcache@lfdr.de>; Sun,  5 Jul 2020 11:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgGEJOi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Jul 2020 05:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgGEJOh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jul 2020 05:14:37 -0400
X-Greylist: delayed 138 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 05 Jul 2020 02:14:37 PDT
Received: from smtp.mfedv.net (smtp.mfedv.net [IPv6:2a04:6c0:2::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F151C061794
        for <linux-bcache@vger.kernel.org>; Sun,  5 Jul 2020 02:14:37 -0700 (PDT)
Received: from suse92host.mfedv.net (suse92host.mfedv.net [IPv6:2a04:6c0:2:3:0:0:0:ffff])
        by smtp.mfedv.net (8.15.2/8.15.2/Debian-10) with ESMTP id 0659CFd8014586;
        Sun, 5 Jul 2020 09:12:16 GMT
Received: from xoff (klappe2.mfedv.net [192.168.71.72])
        by suse92host.mfedv.net (Postfix) with SMTP id C7059C81E6;
        Sun,  5 Jul 2020 11:12:14 +0200 (CEST)
        (envelope-from bcache@mfedv.net)
Date:   Sun, 5 Jul 2020 11:12:14 +0200
From:   Matthias Ferdinand <bcache@mfedv.net>
To:     Coly Li <colyli@suse.de>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: Input requirement for persistent configuration items in bcache
Message-ID: <20200705091214.GL14425@xoff>
References: <0fe47cd9-ffa0-b440-44ca-6ed9419dfb01@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0fe47cd9-ffa0-b440-44ca-6ed9419dfb01@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sun, Jul 05, 2020 at 12:45:41PM +0800, Coly Li wrote:
> While I am thinking about this, I do appreciate your help about the
> input on which configuration item should be stored in the on-disk
> superblock.

Hi,

my use case is rather limited, all my bcache devices run in writeback
mode, and the only parameters I keep playing with are writeback_percent
and sequential_cutoff.

My short list of favourites:

   - cache_mode
   - writeback_percent
   - sequential_cutoff

But I vaguely remember that I used rebooting as last resort after too
much fiddling with tunables; persisting them in the superblock means
losing this reset-to-defaults method. Would be nice to have some other
way of resetting.

An alternative to modifying the superblock might be something
more out-of-band like iptables does with iptables-save and
iptables-restore: convert current settings to text, e.g. on shutdown or
at regular intervals, and restore settings on boot from this text file.

Regards
Matthias
