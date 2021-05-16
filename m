Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB4E381D6D
	for <lists+linux-bcache@lfdr.de>; Sun, 16 May 2021 10:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhEPIqs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 May 2021 04:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhEPIqs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 May 2021 04:46:48 -0400
X-Greylist: delayed 174 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 16 May 2021 01:45:33 PDT
Received: from smtp.mfedv.net (smtp.mfedv.net [IPv6:2a04:6c0:2::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC186C061573
        for <linux-bcache@vger.kernel.org>; Sun, 16 May 2021 01:45:33 -0700 (PDT)
Received: from suse92host.mfedv.net (suse92host.mfedv.net [IPv6:2a04:6c0:2:3:0:0:0:ffff])
        by smtp.mfedv.net (8.15.2/8.15.2/Debian-10) with ESMTP id 14G8gTfj015880;
        Sun, 16 May 2021 08:42:30 GMT
Received: from xoff (klappe2.mfedv.net [192.168.71.72])
        by suse92host.mfedv.net (Postfix) with SMTP id E2B191180F6;
        Sun, 16 May 2021 10:42:28 +0200 (CEST)
        (envelope-from bcache@mfedv.net)
Date:   Sun, 16 May 2021 10:42:28 +0200
From:   Matthias Ferdinand <bcache@mfedv.net>
To:     Thorsten Knabe <linux@thorsten-knabe.de>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: PROBLEM: bcache related kernel BUG() since Linux 5.12
Message-ID: <YKDa9IOPsDJ0Wa8i@xoff>
References: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, May 15, 2021 at 09:06:07PM +0200, Thorsten Knabe wrote:
> Hello.
> 
> Starting with Linux 5.12 bcache triggers a BUG() after a few minutes of
> usage.
> 
> Linux up to 5.11.x is not affected by this bug.
> 
> Environment:
> - Debian 10 AMD 64
> - Kernel 5.12 - 5.12.4
> - Filesystem ext4
> - Backing device: degraded software RAID-6 (MD) with 3 of 4 disks active
>   (unsure if the degraded RAID-6 has an effect or not)
> - Cache device: Single SSD

Sorry I can't immediately help with bcache, but for DRBD, there was a
similar problem with DRBD on degraded md-raid fixed just recently:

    https://lists.linbit.com/pipermail/drbd-user/2021-May/025904.html

Although they had silent data corruption AFAICT, not a loud BUG(), and
they stated problems started with kernel 4.3.

For DRBD it had to do with split BIOs and readahead, which degraded
md-raid may or may not fail, and missing a fail on parts of a split-up
readahead BIO.

Matthias
