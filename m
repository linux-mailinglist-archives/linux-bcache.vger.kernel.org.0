Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F24439D954
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Jun 2021 12:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhFGKNW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Jun 2021 06:13:22 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56632 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhFGKNW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Jun 2021 06:13:22 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D18D121A6C;
        Mon,  7 Jun 2021 10:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623060690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oTpTn43XQSlxJcbV6MwwVU1W80MKxmRlm/6BT9VyCWM=;
        b=lxaCt6vXtB4NzAPnbMQOKyFzOGe5L1lXAAba4RKmLfXfhwWMpTPzyrquN3xxyhgqnJDapH
        g3MPTvdcPRmR2hlvNVIap5dz6Rrwe8oQapcIujeG4fvlj1oJNPf7OMznj8bkbDl6K1dBfb
        ZihBxFQcdqfbUJ0uHgtQ0z2VOAt6q04=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623060690;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oTpTn43XQSlxJcbV6MwwVU1W80MKxmRlm/6BT9VyCWM=;
        b=0MskGXn7MMqZkeFwWBHJrwphM9kmyqB4rFQZiCbjuEkhek1KkMRD191LE4o9TeprgeILor
        Ido+mJ+9jJHrBDDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 11EBB118DD;
        Mon,  7 Jun 2021 10:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623060690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oTpTn43XQSlxJcbV6MwwVU1W80MKxmRlm/6BT9VyCWM=;
        b=lxaCt6vXtB4NzAPnbMQOKyFzOGe5L1lXAAba4RKmLfXfhwWMpTPzyrquN3xxyhgqnJDapH
        g3MPTvdcPRmR2hlvNVIap5dz6Rrwe8oQapcIujeG4fvlj1oJNPf7OMznj8bkbDl6K1dBfb
        ZihBxFQcdqfbUJ0uHgtQ0z2VOAt6q04=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623060690;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oTpTn43XQSlxJcbV6MwwVU1W80MKxmRlm/6BT9VyCWM=;
        b=0MskGXn7MMqZkeFwWBHJrwphM9kmyqB4rFQZiCbjuEkhek1KkMRD191LE4o9TeprgeILor
        Ido+mJ+9jJHrBDDw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id Agw4NdHwvWDJKwAALh3uQQ
        (envelope-from <colyli@suse.de>); Mon, 07 Jun 2021 10:11:29 +0000
Subject: Re: PROBLEM: bcache related kernel BUG() since Linux 5.12
To:     Rolf Fokkens <rolf@rolffokkens.nl>,
        Thorsten Knabe <linux@thorsten-knabe.de>
Cc:     linux-bcache@vger.kernel.org
References: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
 <f2f917d5-330b-a5cc-cca1-fe79a32c2140@rolffokkens.nl>
 <7e3c8a62-71d4-11a7-5dd7-137c030f5aad@suse.de>
 <92f2fb24-0d19-939d-a37a-91b9c1da4ac1@thorsten-knabe.de>
 <2a37723c-bc91-351d-5b0e-e7d104f88141@rolffokkens.nl>
 <69319c4e-71fe-5c7d-955f-801fdb9d9cba@suse.de>
 <5df1c881-02e9-f951-5dbd-016a390d8d54@rolffokkens.nl>
 <709c9a11-686d-9b82-b016-e65fdca41f01@suse.de>
 <ec9f73fa-a16c-b0c1-d1f8-2bf4e585be5f@rolffokkens.nl>
From:   Coly Li <colyli@suse.de>
Message-ID: <2d1d76b3-5eca-f0a6-c300-8e16d25ea1cf@suse.de>
Date:   Mon, 7 Jun 2021 18:11:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ec9f73fa-a16c-b0c1-d1f8-2bf4e585be5f@rolffokkens.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/4/21 9:38 PM, Rolf Fokkens wrote:
> Hoi Coly,
>
> The common applications I used, which for sure benefit from bcache:
>
>   * Gnome 3.38
>   * Libreoffice-7.0.6.2
>   * teams-1.4.00.7556
>   * Terminator
>   * Evolution-3.38.4
>   * Thunderbird evolution-3.38.4
>   * thunderbird-78.10.1
>   * firefox-88.0.1
>   * google-chrome-stable-91.0.4472.77
>
> So it's a typical desktop wordload with most I/O during startup of
> applications.
>
> For overall stress/stability testing:
>
>   * Doom (steam/proton)
>   * Rise of the Tombraider (steam)
>   * The Witcher 3 (steam)
>
> Overall stats after (should have done before) starting the steam games:
>
> bash-5.0$ bcache-status
> --- bcache ---
> UUID                        b191549d-4455-43ca-b9b8-8e32dd68751c
> Block Size                  512 B
> Bucket Size                 512.00 KiB
> Congested?                  False
> Read Congestion             0.0ms
> Write Congestion            20.0ms
> Total Cache Size            128 GiB
> Total Cache Used            128 GiB    (100%)
> Total Cache Unused          0 B    (0%)
> Evictable Cache             106 GiB    (83%)
> Replacement Policy          [lru] fifo random
> Cache Mode                  writethrough [writeback] writearound none
> Total Hits                  3006361    (95%)
> Total Misses                126463
> Total Bypass Hits           4552    (68%)
> Total Bypass Misses         2061
> Total Bypassed              730.1 MiB
> bash-5.0$
>
> Hope this gives you a good impression of the workload.
>
> Let me know if you like me to do specific stress tests.

[snipped]

Hi Rolf and Thorsten,

I run the following workloads for 48+ hours, no panic or data corruption
so far,
- tar, untar, gzip, gunzip
- git clone/fsck/gc/archive
- copy iso files, checksum calculation and check for all the iso files
- kernel source code compiling
- ext4 file system check

The fix might not be perfect yet, but IMHO we should provide a fix now.
If there is any other known issue triggered, let's fix and verify later.

Thank you all for the testing and verification these days.

Coly Li

