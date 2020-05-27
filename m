Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634AB1E3FC2
	for <lists+linux-bcache@lfdr.de>; Wed, 27 May 2020 13:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgE0LWH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 May 2020 07:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgE0LWG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 07:22:06 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FFDC03E979
        for <linux-bcache@vger.kernel.org>; Wed, 27 May 2020 04:22:06 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id bg4so4726803plb.3
        for <linux-bcache@vger.kernel.org>; Wed, 27 May 2020 04:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7gJxdvCpfrIue0RzTQk7obMxzbW3P/jexa322JS6jTk=;
        b=qmgUq0I63dQ2fxzbhTuUO1HPoFuKTJDCCKA0uUwXHJ02CVggXfImEsCyjOw5g1M/B6
         7uy1TbpqSl35DbJJihbShNSfLZWbB5jnC1Q1PHaGWrWF6b3dqqaamxAu8bWXgvdpgeG/
         vGqr7Bh47yvhhjrMyN7G8WxeAZvNQTAkGbFMiMxL304wcD/RlC2ouNW9QkIfbjmT9NG6
         HNDCRMhO+sl+dvr3KX0ePD7uimis7UAIGumlrG7i2AhQ2gF6HpcMYe/fkUJBrA8y8l2f
         hl8lGM/7kjKwl/LsGgfh/4F/KON7ZiAbCb0V/K4votERrdvFnmbuwtmnVkXRCyro4/+p
         YcPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7gJxdvCpfrIue0RzTQk7obMxzbW3P/jexa322JS6jTk=;
        b=B/XMk74Q4N6m3KPBIRp+eKenLN85N2LIgjsCeANe+ihUf/0jgmkQs1xMst0VQn95vn
         E+QnIRTnQ9I8k2RNGJfuwrGToP5Cfo2fWWYPCXHUAaycNi8og5ZUA32aZjhY0Vcm7JxO
         GqFp7TvGJwAUTi4MKOKrK+HQZdJfLVefc5HOp0OX6AVgz1S18ZWGcejkFE1QaDZZJ8Fk
         SHp7OIexuDJvUyGYezz+gnVAk359nKm1Ib8heDfOQo3VstUtIPkYE94pM/QCRMu/Rc4w
         TFWCNIM1PwHuDzN9SMLRTTqGMXd2PdbKhdP7QCgAy+cT+VnsX9bvBLKjcyAtPLhzTMLs
         U1Hg==
X-Gm-Message-State: AOAM530ZCS6na/nRdQhTodZLi62SRkiEFjaln8WESHGjLbEeZmlYG2L9
        +prKVVgzVZnG1GkmfRbA1oRfLIauiFxnwg==
X-Google-Smtp-Source: ABdhPJy6PZ//6S2JWbZAJxsDE8wE3cmlRBZk4jwdGJuMizvUypFmxI08dabu3vfsUXeWFY3+3DUfDA==
X-Received: by 2002:a17:902:d3d4:: with SMTP id w20mr5510652plb.3.1590578526110;
        Wed, 27 May 2020 04:22:06 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:2cc3:8599:f649:862c? ([2605:e000:100e:8c61:2cc3:8599:f649:862c])
        by smtp.gmail.com with ESMTPSA id a16sm2317879pjs.23.2020.05.27.04.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 04:22:05 -0700 (PDT)
Subject: Re: block I/O accounting improvements v2
To:     Christoph Hellwig <hch@lst.de>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
References: <20200527052419.403583-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e807976c-4a6a-ac93-17b4-a6a7dfc438be@kernel.dk>
Date:   Wed, 27 May 2020 05:22:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527052419.403583-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/26/20 11:24 PM, Christoph Hellwig wrote:
> Hi Jens,
> 
> they series contains various improvement for block I/O accounting.  The
> first bunch of patches switch the bio based drivers to better accounting
> helpers compared to the current mess.  The end contains a fix and various
> performanc improvements.  Most of this comes from a series Konstantin
> sent a few weeks ago, rebased on changes that landed in your tree since
> and my change to always use the percpu version of the disk stats.

Applied, thanks.

-- 
Jens Axboe

