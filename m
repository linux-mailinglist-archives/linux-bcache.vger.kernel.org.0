Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8D9F87AE
	for <lists+linux-bcache@lfdr.de>; Tue, 12 Nov 2019 06:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbfKLFEc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 12 Nov 2019 00:04:32 -0500
Received: from mail-ed1-f45.google.com ([209.85.208.45]:33609 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfKLFEc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 12 Nov 2019 00:04:32 -0500
Received: by mail-ed1-f45.google.com with SMTP id a24so10174513edt.0
        for <linux-bcache@vger.kernel.org>; Mon, 11 Nov 2019 21:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lyle-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NJuG6/CC0sxbWGR94MlUTZRXqDWhqWxU/ohxBa0+1T8=;
        b=rhPJABFa37JsEzalAw2eof3w4LrbTfhVhNEKqx9P4U9ysBDhQuIY5znnihZkMwQWgX
         EKF/UUXKx5IQSjJbAQZO6GtaEZBzV8vhOx+JaHViJvyJCna12ydBc8Heovl5Jh1Gu0nl
         0GE3F6WUeI6U1kMouYXatwffMI+r78q6n/r3rWjfQYao3FaCU9Y6N7gucZn1kMp/bSjM
         7atZQfQYra9I1DkL46umlokGRQr94VAQ45TNkjOhIOfmCuzlXjmzx5wFV6Mz9/A0+N1g
         QzBbkZT0FRPmakg714WwjrzX/A0xoCWb5x+0I2VJapQA5T0/gNTj5xoSI7XWv/qNU52Z
         jRng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NJuG6/CC0sxbWGR94MlUTZRXqDWhqWxU/ohxBa0+1T8=;
        b=h6dDbL5fJ7KWCtvPGrGI5qGOUL/JXHiWpppuNSjZfT85ANa+ODB1i5T9K9GRDJhkS8
         iPwZQ4lAnUGecmSPV/jCPWivDxYHfuueBZQcVBLk6rMVrGMI9mNl+prHnt6kdn7AhiZo
         1v3g8c7Uf5VAInDG3FXVYIX6h6IgXtAKvchnIzxSRBkcrrvgpG4humOnL6P6V2UhdTiE
         pT8KKxeU7yTvwFhzsYNl9pAeQvRkl2DRiP5Zs9zsQP2+fTA202pHAA4Web9fP05ALsNO
         VRcPadmpl+qR8eUUwT3hsVCMD/kAtR8et9wUSmTro4Bu7PCHbOCTPqnS2ULrrewD5qVQ
         BYoQ==
X-Gm-Message-State: APjAAAWEa3mi/ovMIKJkJ4wfZaaGHbqHM7YgHSzK+Lpf1BNtn1uilrKN
        lKEL+35IQ7TBOvq0WxCDVwun2l2zdFJvu2eagiYc6w==
X-Google-Smtp-Source: APXvYqwFG2SBnUP6mYJ0Roh898mBbXmO1kjh/hKJJU2GR+z1gAc+TeRstf4IOAMF1d5DcbTzstYA3e1hmYP2EP56ujs=
X-Received: by 2002:a17:906:5151:: with SMTP id s17mr25498503ejl.230.1573535068472;
 Mon, 11 Nov 2019 21:04:28 -0800 (PST)
MIME-Version: 1.0
References: <20191111104219.6d12c4b6@batzmaru.gol.ad.jp> <a138b451-0a3e-2646-111e-cd095699ab0e@suse.de>
 <20191112101739.1c2517a4@batzmaru.gol.ad.jp> <a3d675f1-2309-d3fc-12b9-2ffb38ca5965@suse.de>
In-Reply-To: <a3d675f1-2309-d3fc-12b9-2ffb38ca5965@suse.de>
From:   Michael Lyle <mlyle@lyle.org>
Date:   Mon, 11 Nov 2019 21:04:11 -0800
Message-ID: <CAJ+L6qcBpoud8sHhZ64_3Ce9FfzSSUQeXM8MX82cmkREmuFByA@mail.gmail.com>
Subject: Re: Several bugs/flaws in the current(?) bcache implementation
To:     Coly Li <colyli@suse.de>
Cc:     Christian Balzer <chibi@gol.com>,
        linux-bcache <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Nov 11, 2019 at 9:00 PM Coly Li <colyli@suse.de> wrote:
> It seems Areca RAID adapter can not handle high random I/O pressure
> properly and even worse then regular write I/O rate (am I right ?).

I believe what his data shows is that when the only workload is
writeback, it's all random write and isn't coalesced.  Areca is pretty
good with random write, but because we sort on LBA already the adapter
cache provides no benefit to allow further I/O coalescing.

OTOH, I liked the system we had before where we had at most 1 idle
writeback outstanding at a time, because it was guaranteed to not
create excessive load on the cache or backing device.  I think his
chief objection is that he uses the cache device for other things and
doesn't want its idle utilization to be high.

Mike
