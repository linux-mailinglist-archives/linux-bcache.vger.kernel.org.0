Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B998244DCC9
	for <lists+linux-bcache@lfdr.de>; Thu, 11 Nov 2021 21:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbhKKU50 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 11 Nov 2021 15:57:26 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:58260
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233346AbhKKU5Z (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 11 Nov 2021 15:57:25 -0500
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B90CE3F177
        for <linux-bcache@vger.kernel.org>; Thu, 11 Nov 2021 20:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1636664072;
        bh=MFWszAlHR0LE5x407yW/wjKLlzN6mIIh9U/r4hjx/Tg=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=UxL44P8J5+RxPLP6ylgWtqJ6O0Amn8P7Wqsorucv9ECxIgU2zZuPBnyXkzVjRdjaZ
         ZBt7cMa2emxxMYXXUHCSzODpmfAdEuFHJI+3X8+Ra7baT0adKIIKa34ivFVwrViVpd
         N+TyJgEsLk0yuTXujKpoioZLZuyP5vfcoN2rm74YiEnWnjFht5iiJZkijRhVxGgi4d
         Zw1QjNKpe6/PHoeXbkoT8lCMACNz+X/InYP++jcr/6BQ57o/SBMaA0phULlYYGcxZs
         9cVjL/QR5RlltBsNQAPJyNMScKCHd0P7q3Z5Wie5wbeXclFDImecYTAvLCwHsXLk8J
         Y+Utf0g5ClETw==
Received: by mail-pj1-f72.google.com with SMTP id x6-20020a17090a6c0600b001a724a5696cso3373632pjj.6
        for <linux-bcache@vger.kernel.org>; Thu, 11 Nov 2021 12:54:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MFWszAlHR0LE5x407yW/wjKLlzN6mIIh9U/r4hjx/Tg=;
        b=QMf9IbLDU22O8vNkjFhT6egkA/ELlg4sAbAfgBNo/JjqppcytmPZfqvHzGdkT8vwFk
         0gknAdOsBKSI84yAwaMW5WkkeH9Urum64R3qRVLPVAxxADsGDZLVWkYTtU+E26rDTIJQ
         SpaMTa/YuXJkyCYTZka0GfzuV1spzZpRyHTI8lwd4tSZE/5s/URJgKoTrlcNNCYTxACd
         dLn4MFMzkiXLFUaG0S/B+mQl21QtJUKE0zlIPJK1OEtF55JSOwz9e6xguJaXC4mXHKBt
         bifMzZEsd/B+Fm+Fr4xmwFExWpM+6tGqFt6+pz1FgfrQx0YjKdeIPP0pz/0cXt97Qrmt
         8mTA==
X-Gm-Message-State: AOAM532yjGfgsQ6eHGEfXcielK8eD/oa/OKqKYPRtEA0szAekm5Cb+x2
        DGuHU3o3cSDfFsveyJUf4jef4AhAbgQUvOsHdHDTBLMpAD2kaqoYZS3bAE0fvv85Xilbf2DRVop
        Iq5GSJo9uTe9lgZ2uK5AdjWdV9hzUOAG1DOojEz8I/ICxirdKhPTwfP3VJA==
X-Received: by 2002:aa7:9628:0:b0:494:6dc8:66de with SMTP id r8-20020aa79628000000b004946dc866demr9230133pfg.73.1636664070673;
        Thu, 11 Nov 2021 12:54:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwy2qonneyBRBqUxRUgfkxNpga9ozOGvZLMzXquiU8AucG0x3kbrGnS6uel1TDBbN3hXd4+08Q2MT9qcJArOfc=
X-Received: by 2002:aa7:9628:0:b0:494:6dc8:66de with SMTP id
 r8-20020aa79628000000b004946dc866demr9230099pfg.73.1636664070336; Thu, 11 Nov
 2021 12:54:30 -0800 (PST)
MIME-Version: 1.0
References: <CAC6jXv0mw4eOzFSzzm0acBJFM5whhC=hTFG6_8H__rfA6zq5Cg@mail.gmail.com>
 <YYwn1eT86dvSRfeA@moria.home.lan>
In-Reply-To: <YYwn1eT86dvSRfeA@moria.home.lan>
From:   Mauricio Oliveira <mauricio.oliveira@canonical.com>
Date:   Thu, 11 Nov 2021 17:54:18 -0300
Message-ID: <CAO9xwp006wLDLVAoCPFgp_ogLiCunB8F8rHh9UitXqSmtNqLoQ@mail.gmail.com>
Subject: Re: bcache-register hang after reboot
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Nikhil Kshirsagar <nkshirsagar@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Kent,

On Wed, Nov 10, 2021 at 5:13 PM Kent Overstreet
<kent.overstreet@gmail.com> wrote:
> Your journal is completely full, so persisting the new btree root while doing
> journal replay is hanging.
>
> There isn't a _good_ solution for this journal deadlock in bcache (it's fixed in
> bcachefs), but there is a hack:
>
> edit drivers/md/bcache/btree.c line 2493
>
> delete the call to bch_journal_meta(), and build a new kernel. Once you've
> gotten it to register, do a clean shutdown and then go back to a stock kernel.
>
> Running the kernel with that call deleted won't be safe if you crash, but it'll
> get you going again.

Thanks for the clarification and suggestions.

Would it be OK to implement that workaround if requested by a sysadmin ?
(say, to ack the data safety / crash risk)

Right now the issue is known, reproduces with v5.15, has no good solution,
remains after reboot, prints hung task warnings continuously, and prevents
using the device at all; and this workaround requires kernel dev/build skills.

Since its effects seem bad enough, it would seem fair enough to provide a
way out even if it's not a _good_ one.

Say, we could try and detect the journal full during journal replay, and handle
it by failing the device registration. This would unblock the tasks, and provide
a more intuitive error message. (maybe leading to the next paragraph.)

We could also add a sysfs tunable to skip the call to bch_journal_meta(),
and allow the registration to proceed, but fail it unconditionally in the end
so the device isn't used with data safety / crash risk
(or force an automatic unregister + register again w/ bch_journal_meta(),
and disable the sysfs tunable).

This would help with the full journal, and allow a sysadmin to perform the
workaround without kernel rebuild and reboots.

Thanks!

-- 
Mauricio Faria de Oliveira
