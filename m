Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2DC222DD4
	for <lists+linux-bcache@lfdr.de>; Thu, 16 Jul 2020 23:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgGPVZD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Jul 2020 17:25:03 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:43284 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgGPVZD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jul 2020 17:25:03 -0400
X-Greylist: delayed 1059 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jul 2020 17:25:03 EDT
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id 06GL7J2X002039;
        Thu, 16 Jul 2020 22:07:19 +0100
From:   Nix <nix@esperi.org.uk>
To:     kent.overstreet@gmail.com
Cc:     Stefan K <shadow_7@gmx.net>, linux-bcache@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Subject: Re: how does the caching works in bcachefs
References: <2308642.L3yuttUQlX@t460-skr>
        <20200708220220.GA109921@zaphod.evilpiepirate.org>
        <2900215.XKtEbqh0OK@t460-skr>
        <20200709160805.GA158619@zaphod.evilpiepirate.org>
Emacs:  it's not slow --- it's stately.
Date:   Thu, 16 Jul 2020 22:07:19 +0100
In-Reply-To: <20200709160805.GA158619@zaphod.evilpiepirate.org> (kent
        overstreet's message of "Thu, 9 Jul 2020 12:08:05 -0400")
Message-ID: <87sgdr9njs.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1480; Body=4 Fuz1=4 Fuz2=4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 9 Jul 2020, kent overstreet told this:

> In real world mixed workloads LRU is fine, it's not that much of a difference
> vs. the more sophisticated algorithms. More important is the stuff like
> sequential_bypass or some other kind of knob to ensure your backup process
> doesn't blow away the entire cache.

The ioprio thing that never got integrated into bcache (but is still
available as out-of-tree patches that work fine) is even better for
this: yes, it might not quite be what ioprio was meant for, but it means
the user has the equivalent of 'nocache' that they can apply to entire
process hierarchies that they don't want to pollute the cache, just by
using ionice. Run your backup with ionice -c 3 and now everything, even
the metadata reads, comes from the cache if it's already in the cache
but otherwise stays out of cache.

(This matters if you have a huge amount of metadata that is rarely read
except when the backup sweeps over it, and a not-too-huge cache device.
You don't want to waste cache space on stuff that only the backup is
accessing...)
