Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7273D35996
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Jun 2019 11:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfFEJV7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jun 2019 05:21:59 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38830 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfFEJV6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jun 2019 05:21:58 -0400
Received: by mail-io1-f66.google.com with SMTP id x24so19666125ion.5;
        Wed, 05 Jun 2019 02:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uDjBQkAVbNID/6IEXKOFNSbDIeMHgSat2+m5A0KFo3M=;
        b=RHXwbjIiFnQT8YPT/t/8R6S8Isf5kbM4MgtKHCD0NGKh7HLa8sPQgTVk8v1qNWpoiF
         Rhq+9Yl7c1ZJD05i62ck5l4Y0RpNoDGDNJYAqbn8ugHSy9iP9/N6BRYkxY+32oN4YYJp
         5EtMvW0TcWwmXCiGyXTHksDh/tmoIJfl3gbaU11q8+EgrCPCc9y75svoD2y70J6e8RB7
         6v1AuZlQcyqU5Kf6d+RnJEP6LR7dtuKsB8Mm048NlWPsa/8jKOyVelcKUBFB5Ab/vhQ5
         ugL6ThWymA5ec//v8iLYg/N2yHP2fxhwYmJgqYZZHweVhkd7DTPZPR+OBDj7+icJ5t4/
         W2Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uDjBQkAVbNID/6IEXKOFNSbDIeMHgSat2+m5A0KFo3M=;
        b=g+lPA+j5B1lomooTS0QnRIXZZDZulY8jRCbYkPN55reubgVPsluOQAg6vKjqVt9vbx
         gi1yqG1KPICeXab+A5BOofc098zIW5Smg12lJUduB/Jz4ho7nPRC1S1JAdQw7blhp04u
         wQ5SYdy0h6c8LZKCxtGcGf7nWNuO+QZnCfGud9qYVcn8uDVy+83i31BEqg4R9qTHbmHI
         qbRKi0Ws3GgYgDUqYBAUV5s13bVG+lmB1YAhRuELbqFbLgUHHe/0TD5rDzOy+AikfXAo
         B3YwBxby7KT9VhlAdsGk/m+r0UgxTS5Pcwd2wdlwCQ5A3AiAhGl89GaKlHQIubFym2qE
         pQeQ==
X-Gm-Message-State: APjAAAU2F6wGWxk8hQABzfIvX5huqvwh9v6tHjXYU/ypjmBpIhaL9ik/
        d44hyemTlpqeY4/uTvcY20PK58QgCroKVF6mCw==
X-Google-Smtp-Source: APXvYqzhrwM6pEU0bDIofrePlo2VCS3ovjf/uem6DKwoveAH/lvCKMoeaEMwWSWxTZo0WaInVh5mjHoL5EIGlDYHtoI=
X-Received: by 2002:a6b:7d09:: with SMTP id c9mr24679346ioq.245.1559726517832;
 Wed, 05 Jun 2019 02:21:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAEYzJUH1L5qyWKN3_s4Sz81frho6nKB9bkyDoGxXCvLNO484ew@mail.gmail.com>
 <6823d3ab-5f93-da74-0dbc-19bdb7be6907@suse.de> <3399cad5-4387-dd23-77f1-a70e551fb531@suse.de>
 <CAEYzJUE0SuO3uHm1TTxfr1kPtLic1ggUPnGFYTSPcwk6nfq82g@mail.gmail.com> <78880cf8-07c6-e00d-0084-ce9c211eeec6@suse.de>
In-Reply-To: <78880cf8-07c6-e00d-0084-ce9c211eeec6@suse.de>
From:   =?UTF-8?Q?Bj=C3=B8rn_Forsman?= <bjorn.forsman@gmail.com>
Date:   Wed, 5 Jun 2019 11:21:46 +0200
Message-ID: <CAEYzJUFUxgQXDTOf5ai9+9UijEL-Eb+_91UbVPC2hc=8G-++4Q@mail.gmail.com>
Subject: Re: bcache: oops when writing to writeback_percent without a cache device
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, 5 Jun 2019 at 06:41, Coly Li <colyli@suse.de> wrote:
>
> On 2019/6/5 1:24 =E4=B8=8A=E5=8D=88, Bj=C3=B8rn Forsman wrote:
> > On Tue, 4 Jun 2019 at 17:41, Coly Li <colyli@suse.de> wrote:
> >>
> >> On 2019/6/4 10:59 =E4=B8=8B=E5=8D=88, Coly Li wrote:
> >>> On 2019/6/4 7:00 =E4=B8=8B=E5=8D=88, Bj=C3=B8rn Forsman wrote:
> >>>> Hi all,
> >>>>
> >>>> I get a kernel oops from bcache when writing to
> >>>> /sys/block/bcache0/bcache/writeback_percent and there is no attached
> >>>> cache device. See the oops itself below my signature.
> >>>>
> >>>> This is on Linux 4.19.46. I looked in git and see many commits to
> >>>> bcache lately, but none seem to address this particular issue.
> >>>>
> >>>> Background: I'm writing to .../writeback_percent with
> >>>> systemd-tmpfiles. I'd rather not replace it with a script that figur=
es
> >>>> out whether or not the kernel will oops if writing to the sysfs file
> >>>> -- the kernel should not oops in the first place.
> >>>
> >>> Hi Bjorn,
> >>>
> >>> Thank you for the reporting. I believe this is a case we missed in
> >>> testings. When a bcache device is not attached, it does not make sens=
e
> >>> to update the writeback rate in period by the changing of writeback_p=
ercent.
> >>>
> >>> I will post a patch for your testing soon.
> >>
> >> Hi Bjorn,
> >>
> >> Could you please to try this patch ? Hope it may help a bit.
> >
> > Hi Coly,
> >
> > Thanks for the quick patch! I tested it on linux 5.2-rc2 and it indeed
> > fixes the problem.
> >
> > There is one typo in the patch/commit message: s/writebac/writeback/
> >
>
> Hi Bjorn,
>
> Thanks for the patch review. Do you mind if I add Reviewed-By: tag with
> your name and email address ?

Yes, you can add my Reviewed-By: tag.

--=20
Bj=C3=B8rn Forsman
