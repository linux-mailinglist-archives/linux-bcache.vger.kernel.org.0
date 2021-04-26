Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511EE36B6B7
	for <lists+linux-bcache@lfdr.de>; Mon, 26 Apr 2021 18:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhDZQYq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 26 Apr 2021 12:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhDZQX4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Apr 2021 12:23:56 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E549BC061574
        for <linux-bcache@vger.kernel.org>; Mon, 26 Apr 2021 09:23:14 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id o17so12274675vko.8
        for <linux-bcache@vger.kernel.org>; Mon, 26 Apr 2021 09:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=epqiHekZGeihTqI/Vtgx5Co0pqDmygQtsRwLHV39Ojo=;
        b=SitRysLLmGxidR7oJLndEIab2q6FXd+L3k9zD9aT/692IY1qd6cP2o44E3b8Qe9iN9
         04KXtmgGyRfwriABP6oknQa1VWUklRFFpYI01YbmCCRo50RX4O3jWUPtYAapdoydOCTk
         JIYzuxQkt9qDHRCxJ5Pg58mdtVsMEZd7IvcH4K3SkGJpzGvIKcECPe91JSYCyjYlG0D+
         +dbQ5eck1IF937AtJQYTjICc4U1sVr6OLf1kWmkvPY9IIVlaTK1ZtJrQ5K9Pgl03CoD4
         mwIPJAIqeoXJnUSQT1PLWhRpyOq1WEaJWrZM8t5iAgpQoT3gBzaQG1WUD7c548mBo3qs
         fKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=epqiHekZGeihTqI/Vtgx5Co0pqDmygQtsRwLHV39Ojo=;
        b=foZ6czKLdVLWInOjI3JomeVpxZ8JxkT8kVcXp/7xS9hX51RAKV+4LU9aBpuzZWhs5L
         wyuDYrXdeZLmsiZpuQUjI5vWjTW/kJe+YNjH5UXXO7tOZtPpzp9l4EvysI4ExwW7doVx
         cs7s6nUX5psLJ1/QiZow03HeT/8rt1XmUB+TbGxcZKkuWICMsP11j4i3L96HmcGRneHD
         1uk57nPYhjgqYAOQKimmsbtTTXwV9hoQd+tdFGu9CN2m+p1If0c7lVELeq/Fzydx2Ekb
         z3MMj/Ezin/yX4qEhxhUmMk5+TesJITVKp2fVXQg5xYvtsfzMqvzWMonyM+Qmj6RnTGR
         Ai+w==
X-Gm-Message-State: AOAM532P+xwYNqZ68mvVXhlHW5f42vBxkb7SZJ6AEZDivsY6xTos938/
        dhzQo3G+fca7VsX5HyL2+p/WROVUFwXpV44I4gBAf9Da
X-Google-Smtp-Source: ABdhPJwwDhvvJwwQwrETMog17e2cmvIVFZ/Q55h4nxXMlwqMP8Y2RCIyWSdG3YQvToSR1tmtADQtLu4zjwwM55KNtpw=
X-Received: by 2002:ac5:c96c:: with SMTP id t12mr13573212vkm.23.1619454194076;
 Mon, 26 Apr 2021 09:23:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAH6h+heRQ0m4widKfWSfsqptO0xiXA4BW1pVHow2_+JbNrvZUQ@mail.gmail.com>
 <e61bcc44-5ac1-e58c-d5c9-fb7257ba044d@suse.de> <CAC2ZOYvKZBFRPi+-BB8vyTWhMoTGsQZ+7vuFfDmBzpSjzwvVYg@mail.gmail.com>
 <f12265e4-e8e4-98ac-cb5e-c44e8f8941a2@suse.de>
In-Reply-To: <f12265e4-e8e4-98ac-cb5e-c44e8f8941a2@suse.de>
From:   Marc Smith <msmith626@gmail.com>
Date:   Mon, 26 Apr 2021 09:23:04 -0700
Message-ID: <CAH6h+hdAzaLwZUeF9AaV7Dse=dbgMfPW4o9p7QaqbxAcawPUFg@mail.gmail.com>
Subject: Re: Race Condition Leads to Corruption
To:     Coly Li <colyli@suse.de>
Cc:     Kai Krakow <kai@kaishome.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Apr 23, 2021 at 8:53 AM Coly Li <colyli@suse.de> wrote:
>
> On 4/23/21 6:19 AM, Kai Krakow wrote:
> > Hello Coly!
> >
> > Am Do., 22. Apr. 2021 um 18:05 Uhr schrieb Coly Li <colyli@suse.de>:
> >
> >> In direct I/Os, to read the just-written data, the reader must wait and
> >> make sure the previous write complete, then the reading data should be
> >> the previous written content. If not, that's bcache bug.
> >
> > Isn't this report exactly about that? DIO data has been written, then
> > differently written again with a concurrent process, and when you read
> > it back, any of both may come back (let's call it state A). But the
> > problem here is that this is not persistent, and that should actually
> > not happen: bcache now has stale content in its cache, and after write
> > back finished, the contents of the previous read (from state A)
> > changed to a new state B. And this is not what you should expect from
> > direct IO: The contents have literally changed under your feet with a
> > much too high latency: If some read already confirmed that data has
> > some state A after concurrent writes, it should not change to a state
> > B after bcache finished write-back.
>
> Hi Kai,
>
> Your comments make me have a better comprehension. Yes the staled key
> continues to exist even after a reboot, it is problematic.
>
>
> >
> >> You may try the above steps on non-bcache block devices with/without
> >> file systems, it is probably to reproduce similar "race" with parallel
> >> direct read and writes.
> >
> > I'm guessing the bcache results would suggest there's a much higher
> > latency of inconsistency between write and read races, in the range of
> > minutes or even hours. So there'd be no chance to properly verify your
> > DIO writes by the following read and be sure that this state persists
> > - just because there might be outstanding bcache dirty data.
> >
> > I wonder if this is why I'm seeing btrfs corructions with bcache when
> > I enabled auto-defrag in btrfs. OTOH, I didn't check the code on how
> > auto-defrag is actually implemented and if it uses some direct-io path
> > under the hoods.
>
> Hi Marc,
>
> It seems that if the read miss hitting an on-flight writethrough I/O on
> backing device, such read request should served without caching onto the
> cache set.
>
> Do you have a patch for the fix up ?

Yes, we do have a patch that we are testing and would like to be
advised if it's the correct/acceptable approach. I'll post what we
have shortly.

--Marc


>
> Thanks.
>
> Coly Li
