Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBD62A1857
	for <lists+linux-bcache@lfdr.de>; Sat, 31 Oct 2020 15:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgJaO65 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 31 Oct 2020 10:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbgJaO64 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 31 Oct 2020 10:58:56 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560C1C061A04
        for <linux-bcache@vger.kernel.org>; Sat, 31 Oct 2020 07:58:55 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b3so7554716pfo.2
        for <linux-bcache@vger.kernel.org>; Sat, 31 Oct 2020 07:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0zr0b/y5rkNm6oxrz4+W0bMdaVZDG5gT02DeVbHw98o=;
        b=uVP5oeGo2YZHfMjuITKgMCFLRKszKlLHhu3NYhX0ToMOD9q3WR0wGFUFkWhaYhtsqt
         BAXEhyU8dThRZMaOj2G/t8Pe1U4C83abPqUdJdvBRsprfX4o3o0dNPUzXz+OTNzS4Hsp
         CUEhW0B8wY/RY+Th4RHI/09LirVvsxeVY9fEajaAgZIl+25Fb/2PCrfAyx476Qzl+TQm
         CUUJidojEoMdNDmnDrCZARO6HcTvO8Caib55eG/L0aYjM/BPpAQIazpSmTMFoYpfInIj
         RX3g3AP8AH3sA5rTGyq6Ghbu2bsLlNEE7x6UAT9gEFpa4OPcO4FgxEZBWLDJaVVE+aiH
         YKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0zr0b/y5rkNm6oxrz4+W0bMdaVZDG5gT02DeVbHw98o=;
        b=NQKFmA4n4BNXc+zA6Zf+nijUKUVN0J6RGm61grukJR8iRYoAm5cbwtFoGQo56eLzTj
         ydk0oZ5vhxks1Exk2NOsKGRDjB/KacMj4K5T9QbzxWuBXN+zXHWyjSKERAwcUIEL+atI
         i+vPsz3H6Cj8AJd9m2RooBi+pZDxtoOaC1DEXU8oxVACnMFzPvkPAMnBk1oGh9yLKiZE
         r2mJ9VRavlGpEx0PQByxxEglUKoi5wBKo+gvgfvpRzVypjt6pR+Br/ttG879AInnKvwC
         k6nQEVt+VIfSok0EdXZYttJO4mwJcRrjPLnxYbhg0XFPvjXF/h8MvJ5JRIBjQESZJC5C
         Xdkg==
X-Gm-Message-State: AOAM531iHPeqwWH3BCX7esnevoLhyQCB7v9kXuLvu9s/sDoqDJX5oWnU
        RNpi92IAVsOVKcrRoZuYylSZMA==
X-Google-Smtp-Source: ABdhPJxu4Rg5DJXBVruN6ahpydQKdUXsdC1eafH3KHv2+x9uXffRNUui5KAFMqg9AwAVU2K7WSB8Ww==
X-Received: by 2002:a63:1b41:: with SMTP id b1mr6826953pgm.274.1604156334647;
        Sat, 31 Oct 2020 07:58:54 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q84sm9374774pfq.144.2020.10.31.07.58.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 07:58:53 -0700 (PDT)
Subject: Re: [PATCH 02/11] mtip32xx: return -ENOTTY for all unhanled ioctls
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
References: <20201031085810.450489-1-hch@lst.de>
 <20201031085810.450489-3-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f128e8bb-7ce4-b8f4-80cb-1afab503887c@kernel.dk>
Date:   Sat, 31 Oct 2020 08:58:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201031085810.450489-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/31/20 2:58 AM, Christoph Hellwig wrote:
> -ENOTTY is the convention for "driver does not support this ioctl".
> Use it properly in mtip32xx instead of the bogys -EINVAL.

While that's certainly true, there is a risk in making a change like this
years after the fact. Not that I expect there are any mtip32xx users
left at this point, but...

-- 
Jens Axboe

