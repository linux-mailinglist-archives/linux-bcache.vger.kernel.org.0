Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DA8402839
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Sep 2021 14:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhIGMIJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 7 Sep 2021 08:08:09 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:43092 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343885AbhIGMII (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Sep 2021 08:08:08 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 187C70P2019659
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 7 Sep 2021 13:07:00 +0100
From:   Nix <nix@esperi.org.uk>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: 5.11: WARN on long-running system
References: <87o89c4et5.fsf@esperi.org.uk>
        <52ea2e1a-041d-b182-f345-c8c531dd4613@suse.de>
Emacs:  The Awakening
Date:   Tue, 07 Sep 2021 13:07:00 +0100
In-Reply-To: <52ea2e1a-041d-b182-f345-c8c531dd4613@suse.de> (Coly Li's message
        of "Tue, 7 Sep 2021 12:12:43 +0800")
Message-ID: <87h7ewy4gr.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: loom 1290; Body=2 Fuz1=2 Fuz2=2
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7 Sep 2021, Coly Li verbalised:
> On 9/1/21 9:15 PM, Nix wrote:
>> It is notable that the unused % of this cache volume has fallen to only
>> 3%: it's quite likely that this warning was emitted when it finally
>> (after three years or so!) ran out of free space and did its first
>> forced GC. I'm not sure how to tell.
> Hi Nix,
>
> I have the similar feeling as yours, that it has been a long time after previous gc running. I have no idea why the gc didn't run
> for such long time (this bucket was reused for 96 times). Let me try to find if there 
> is any clue why the gc does not work for such long time.

It's probably just that my cache is 350GiB and it takes a long, long
time to fill that up. (As in, the unused % has been falling slowly for
three years and it's only just got close to zero in the last few
months.)

(Some GCs have run, but I have no idea why, given that when they ran the
unused % was about 40%.)
