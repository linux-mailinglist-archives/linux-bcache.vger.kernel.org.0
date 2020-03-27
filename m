Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB44195A54
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Mar 2020 16:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgC0PxU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Mar 2020 11:53:20 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:47082 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgC0PxU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 11:53:20 -0400
Received: by mail-pf1-f182.google.com with SMTP id q3so4669917pff.13
        for <linux-bcache@vger.kernel.org>; Fri, 27 Mar 2020 08:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sWk+hApPwex2IKKy9wQGNeWq5d+BD3CZyZ8lOi8iJYI=;
        b=Sjpfqm3APBWDQwQ00ym5Ogfva4349koZT1DMWkCBMPXBWsww9/fwwRFW8NJwBQpo6M
         dtKicKjRNLcZsxeUPJ9D8Nq79dI6QhzGKfj1sfHksqdTicPze2p2n6JFsqhKVObMdiOz
         bpxkZsM3WP2O3DyCYzkD5tKX3H0nZADxst/XkunducEjmRAYyuCTUvmeQGnTzs/wX414
         f8iOA8bjfZ4BHleGemKc9km4lFYe9cxdKM+qUmJ2OZpQyYlADHtKhbSwTbE52Bham3SE
         2AJ/1tpLU897oJ6oPooau0u4Ep/yPdYLreJv3vyYOdNwQ78xe1SHaygNbBN0iG4TqEYS
         WcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sWk+hApPwex2IKKy9wQGNeWq5d+BD3CZyZ8lOi8iJYI=;
        b=cUlUwDA+GKHVt7uXOu0oliibIaHQ+DcBhZnXvAtkg+S3xXgGVRoyf9weYpCV5A7Wm4
         GFXtlfKjuGDn29AUVadody5cShIwMr94rn9k2uI98GstrMflZ4oMuvnL9CBnqJXkoFBx
         eaKtFZVcv6d7DqEdTGsMW1yprYTXl6iUov8UFgEcZ0HtYniSXi1TsbXOAI+2NyBqR1IP
         bUGRxH05BbHRaQdJ9UbnmG+tuGdRd9EAvW4sf6skG2FfKuHmGP0d1nXKhXxURJnFDJHI
         Vtn8asKaNQeAKkrguSW1l8yGRgTADyEg2QwutGfwmTa4xbqqTls/J4y38SlGOmd4aN8t
         EdkQ==
X-Gm-Message-State: ANhLgQ30Rd02cJOBtss4uoVZOkI7WX6Ey8+mHTbSbOg2v/B1l1tBP2Ey
        5i4/Y0BDiShSORJJcMD0gUkPBaUjHysYzQ==
X-Google-Smtp-Source: ADFU+vuTgeJ3+x9d7VGsaoGJIXdNgMMdesEQxfqDGXyq5dTlpp/aOASkik/jnESepAtaKr0b7+yq/w==
X-Received: by 2002:a62:3207:: with SMTP id y7mr15223301pfy.270.1585324399159;
        Fri, 27 Mar 2020 08:53:19 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id r70sm4406361pfr.116.2020.03.27.08.53.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 08:53:17 -0700 (PDT)
Subject: Re: simplify queue allocation
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200327083012.1618778-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b1123d19-0c4a-5d3d-d0d4-0a412830c2b0@kernel.dk>
Date:   Fri, 27 Mar 2020 09:53:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200327083012.1618778-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/27/20 2:30 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series ensures all allocated queues have a valid ->make_request_fn
> and also nicely consolidates the code for allocating queues.

This seems fine to me, but might be a good idea to shuffle 4/5 as the
last one, and do that one inside the merge window to avoid any potential
silly merge conflicts.

-- 
Jens Axboe

