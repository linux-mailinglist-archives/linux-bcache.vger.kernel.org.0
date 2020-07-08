Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E55A219398
	for <lists+linux-bcache@lfdr.de>; Thu,  9 Jul 2020 00:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgGHWh5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 8 Jul 2020 18:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgGHWhh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 8 Jul 2020 18:37:37 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F432C061A0B;
        Wed,  8 Jul 2020 15:37:37 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id u8so80357qvj.12;
        Wed, 08 Jul 2020 15:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bdl0GkH3dl1xFjFiR2PQUXr8eAUbBkwzt6jt3dsUenU=;
        b=TEh63ew9MxLgOfHqxZK/AF0b+FAlRatp5Jz+9M+Qycv2etyvgh0t7FvmLMOgXu56Z8
         /cdgSZE477n6FI8OxzIptYcvRCXw19zZxxMpa6mZEvYZ+Vz2NvwxpoksP0i429KwhMPE
         efMVhS4Iix6bJO/UZ9CWPIC+kw+6TaVQG1tv+jTw96qY5QMXp3vO2l9ITKpSAld//qYQ
         qhKkKNlIbkqC/aDS4LwSuXY7FEqF3zx9AqwZxfzqP1l7l5eze6ju685W7Xp6KVj2P/lV
         uRQg2n3JpRWF4rvX9MZi6eXKIIV0YZFo/J2wsVdcH1CxTvjGBfS6TlrltlqgkChX7Y9V
         qPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bdl0GkH3dl1xFjFiR2PQUXr8eAUbBkwzt6jt3dsUenU=;
        b=jvmZjcuiaXMhlYhQ5yn4285RpZpZSjANNzVyvplUUGci3hSnHynJ1K38cLbrLbBu+B
         OzlcBveu0zY2J3qqtk/a8YZCBSEj1ugpgXiBg4XG8jT2auTwRwgT+ZNUxmyp+pl31Zx2
         dkcmkSNPtZlTPWo2doYNDED8SjanWzhkvgXU67d78W1+DeezVY57SgrZYrenyJu0boSU
         89vJYpKYnwgUj1GIK7I7/mjbZsOiGFuCugnrx1hpueGbBcWuiN3TkgK2s/vZrs1HdQZ8
         ADNKy8zhdEJ81kFapK8XERfZctfucI9OG+StomiFvmLT+6eKSCpzrrrKAecGXjNSLTQp
         jQDA==
X-Gm-Message-State: AOAM531V+fyz7KMZUKWpgpkJFamngjj1jTjpAhc0e51+N+qjxqBNB2q6
        JkeZh01cewJoNL/pX7zwSw==
X-Google-Smtp-Source: ABdhPJyaRUy4E8UDcsaSTJwKg5Yh6lzSnR4y/vy/scr6Qn+8Y4D+ufvWm06KySepQDYQEM/mEwoUPA==
X-Received: by 2002:a0c:b48e:: with SMTP id c14mr31936553qve.47.1594247856397;
        Wed, 08 Jul 2020 15:37:36 -0700 (PDT)
Received: from zaphod.evilpiepirate.org ([2601:19b:c500:a1:56b:8096:bb6:ca58])
        by smtp.gmail.com with ESMTPSA id o21sm1347855qtt.25.2020.07.08.15.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 15:37:35 -0700 (PDT)
Date:   Wed, 8 Jul 2020 18:37:29 -0400
From:   kent.overstreet@gmail.com
To:     Stefan K <shadow_7@gmx.net>
Cc:     linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: how does the caching works in bcachefs
Message-ID: <20200708220220.GA109921@zaphod.evilpiepirate.org>
References: <2308642.L3yuttUQlX@t460-skr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2308642.L3yuttUQlX@t460-skr>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jul 08, 2020 at 11:46:00PM +0200, Stefan K wrote:
> Hello,
> 
> short question: how does the caching works with bcachefs? Is it like  "first
> in first out" or is it more complex like the ARC system in zfs?

LRU, same as bcache.

> The same with the write-cache,  will be everything written to the SSD/NVMe
> (Cache) and then to the HDD? When will will the filesystem say "its written to
> disk"? And what happens with the data on the write cache if we have a
> powerfail?

Disks that are used as caches are treated no differently from other disks by the
filesystem. If you want bcachefs to not rely on a specific disk, you can set its
durability to 0, and then it'll basically only be used as a writethrough cache.

> 
> And can I say have this file/folder always in the cache, while it works "normal" ?

Yes.

So caching is configured differently, specifically so that it can be configured
on a per file/directory basis. Instead of having a notion of "cache device",
there are options for
 - foregroud target: which device or group of devices are used for foreground
   writes
 - background target: if enabled, the rebalance thread will in the background
   move data to this target in the background, leaving a cached copy on the
   foreground target
 - promote target: if enabled, when data is read and it doesn't exist in this
   target, a cached copy will be added there

So these options can be set to get you writeback mode, by setting foreground
target and promote target to your SSD and background target to your HDD.

And you can pin specific files/folders to a device, by setting foreground target
to that device and setting background target and promote target to nothing.
