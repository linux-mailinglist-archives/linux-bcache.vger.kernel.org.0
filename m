Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A87425AF61
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Sep 2020 17:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgIBPiP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Sep 2020 11:38:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58412 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgIBPhz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Sep 2020 11:37:55 -0400
Received: from mail-ua1-f70.google.com ([209.85.222.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <mauricio.oliveira@canonical.com>)
        id 1kDUpd-00036o-Hv
        for linux-bcache@vger.kernel.org; Wed, 02 Sep 2020 15:37:53 +0000
Received: by mail-ua1-f70.google.com with SMTP id s1so1201329uaq.2
        for <linux-bcache@vger.kernel.org>; Wed, 02 Sep 2020 08:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5XT8FH658+UnlXtrtL3pbmeeK63GhhER68XIwLBWqqM=;
        b=UhHRNUX8Oo84FlW8+G/MjbMoFbamvyK0nHeB9EUBQeD9wXjl0U38Af4WUgE+GqE9Ew
         9+AyIuQjAYPrrqOR/DEYs7MZDmvYl46SkJ5a8USYAJC0IiHY7yBubBwHJfCzfUablnbK
         /jwZtHY56qRPuY0jNcGZ1VTcpCKNw5P9NNObC3DgYY8Kiu9Izapfa+YSfqreIuRT95YG
         1QILuErs2u4Jbta3cfivsCzs9VrN3W5RGTdWdgQZClptdcxRSSNq4XvO/VUv3L6eiFQz
         lzvqX0jCtgEx34yqmsn8VRYA1NBMAyXgqJfAf4UJ5//lNS4SCOnk2RlBLrNtxINXLZsH
         N4wg==
X-Gm-Message-State: AOAM5315WIXv+9lbBOhnOPAU36kJpNN8/lbBFwT3mBcaTpecrpsNhQZJ
        MDrQreZ8CcSHvm7hoD5bf/9b9M4HEifrZC5bLNFqavdF6td/c1XnFyMFJbEjO1bHF4Ip7/TN1U3
        TycrvfabM+8ZNJpLmUVRcPoYzUB63XSeL8wL6S9IX/ddo0fDYlQa5cAxQGQ==
X-Received: by 2002:ab0:2705:: with SMTP id s5mr5355387uao.126.1599061072548;
        Wed, 02 Sep 2020 08:37:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWA/MX7yk9PA6HmlOf7IcoizuC7BPzi4mXQaD+qirNN2WUlocEE5xDqBAvefurTZ+K5XfFFL/Sx7fB8ClnN5Y=
X-Received: by 2002:ab0:2705:: with SMTP id s5mr5355365uao.126.1599061072279;
 Wed, 02 Sep 2020 08:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAKkfZL0FR=PX5roCpB9HQe5=F6T70F7+8EFL_yTZPEbqWWHKPA@mail.gmail.com>
In-Reply-To: <CAKkfZL0FR=PX5roCpB9HQe5=F6T70F7+8EFL_yTZPEbqWWHKPA@mail.gmail.com>
From:   Mauricio Oliveira <mauricio.oliveira@canonical.com>
Date:   Wed, 2 Sep 2020 12:37:40 -0300
Message-ID: <CAO9xwp3hniUNqVj14=TpZAoQMjA5v_BOSENcj423_qRqps5H5w@mail.gmail.com>
Subject: Re: Bcache in Ubuntu 18.04 kernel panic
To:     Brendan Boerner <bboerner.biz@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Brendan,

The correct place for Ubuntu bugs is Launchpad, initially.
(It might be the case that it turns out to be an upstream/not
Ubuntu-specific bug, but we'll go from there.)

As Matthias mentioned, recently the patch for the non-512/4k block size
(which was an upstream issue, actually) has been released to Ubuntu
18.04 4.15-based kernel.

You can check if your stack trace is listed in LP#1867916 [1], for example.
And/or test whether the newer kernel version with its fix addresses your issue.

If not, please click 'Report a bug' against the 'linux' package in [2].

Hope this helps,

[1] https://bugs.launchpad.net/bugs/1867916
[2] https://launchpad.net/ubuntu/

On Tue, Sep 1, 2020 at 5:43 PM Brendan Boerner <bboerner.biz@gmail.com> wrote:
>
> Hi,
>
> I spent the weekend verifying and isolating a kernel panic in bcache
> on Ubuntu 18.04 (4.15.0-112-generic #113-Ubuntu SMP Thu Jul 9 23:41:39
> UTC 2020).
>
> Is this the place to report it? I have kernel crash dumps.
>
> Thanks!
> Brendan



-- 
Mauricio Faria de Oliveira
