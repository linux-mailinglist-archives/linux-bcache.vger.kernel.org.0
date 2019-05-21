Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9757E24F90
	for <lists+linux-bcache@lfdr.de>; Tue, 21 May 2019 15:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfEUNCR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 May 2019 09:02:17 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:59182 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbfEUNCR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 May 2019 09:02:17 -0400
X-Greylist: delayed 1537 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2019 09:02:16 EDT
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id x4L92X9F006138;
        Tue, 21 May 2019 10:02:33 +0100
From:   Nix <nix@esperi.org.uk>
To:     Coly Li <colyli@suse.de>
Cc:     Thorsten Knabe <linux@thorsten-knabe.de>,
        linux-bcache@vger.kernel.org
Subject: Re: BUG: bcache failing on top of degraded RAID-6
References: <557659ec-3f41-d463-aa42-df33cb8d18b8@thorsten-knabe.de>
        <c11201ba-094a-db5b-4962-1dbafd377c85@suse.de>
        <0df416df-7cb7-05a4-e7ff-76da1d128560@thorsten-knabe.de>
        <efd60c92-e2f7-c07d-dc03-557eeee1ae3a@suse.de>
        <d8473b88-1f3c-145c-0ca8-e8c207f47d38@thorsten-knabe.de>
        <29b5552f-39b5-b0b9-80ec-cc4a32bcba78@suse.de>
        <3a5e949b-c51c-01ab-578c-ed4883522937@thorsten-knabe.de>
        <56663d65-02d3-2d55-9e90-d02987f61f7d@suse.de>
        <3153278c-0203-3ce5-5de3-40f08d409173@thorsten-knabe.de>
        <61323026-f168-b472-41f8-57c42a7fd0cc@suse.de>
        <63fc8271-f5a5-7fc3-9f4b-d8a610cf70b0@thorsten-knabe.de>
        <2515e3b2-1626-2206-add1-550a9dd34dee@suse.de>
        <2a444578-1828-763b-88ca-e1cda46864d2@thorsten-knabe.de>
        <3ac24c5b-05f5-560d-12d5-57acdb96e50a@suse.de>
        <21269f9e-194a-b86c-1940-c63450c1ac55@suse.de>
Emacs:  no job too big... no job.
Date:   Tue, 21 May 2019 13:38:41 +0100
In-Reply-To: <21269f9e-194a-b86c-1940-c63450c1ac55@suse.de> (Coly Li's message
        of "Mon, 13 May 2019 23:36:43 +0800")
Message-ID: <87h89of0dq.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: loom 1290; Body=3 Fuz1=3 Fuz2=3
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 13 May 2019, Coly Li said:
> Since there is no simple way to detect whether the backing divice is a
> md raid device

Is this really true? I find this very surprising. Lots of mkfs programs
can detect exactly this (to determine the RAID stripe width), and it's
obvious in sysfs as well...

>                  this patch simply ignores I/O failures for read-ahead
> bios on backing device, to avoid bogus backing device failure on a
> degrading md raid array.

... but this feels like a good idea in any case. Readahead is a
performance optimization: if it fails, it is not a user-visible sign of
device failure in the same way that explicit I/O or metadata I/O is.

-- 
NULL && (void)
