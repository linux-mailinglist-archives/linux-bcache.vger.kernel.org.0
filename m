Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959053E9C02
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Aug 2021 03:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhHLBlJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Aug 2021 21:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbhHLBlJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Aug 2021 21:41:09 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47755C0613D3
        for <linux-bcache@vger.kernel.org>; Wed, 11 Aug 2021 18:40:45 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id a8so6692436pjk.4
        for <linux-bcache@vger.kernel.org>; Wed, 11 Aug 2021 18:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QBCEaZn4CkWRVtl+4I6ERHHpNUJaxKMTsA/sipIS2t8=;
        b=CM78Fh2Auz/7fwp3c1OCG1ZarsHT0uzIu+sCKUYn2QgLIlt51/uN8Ng2sX4wJlxHrV
         8rd96CJaVdL873wttibwIjmkjaNugm3J7k5z2hmsvwXOLrbg7xl4hkftSfZFk+kj/j8Q
         ydIy8DFRMpJsr/hFQDN6hJTgW+IUlNZBo7tr5ePW8evU1U+oTSgO7u3Px7YaiQCSzn1h
         FR750BuKAa83EL0e9kRGzjErM6xFdMUAI7zjHdkqUKZ6YywF5/ahW/9bb9WGNogNjmS1
         K0zRqG4Zyftq57BC6TFVAYbBeJrjz0SnwGv7ymjL4LaEbpXdyzzgGRtTI24BSRCgYrlI
         u9dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QBCEaZn4CkWRVtl+4I6ERHHpNUJaxKMTsA/sipIS2t8=;
        b=H3bz0P5gi0uZcMAVGzwJlIjyuoEQWO1h+cIPDsZgZ9prhAhIi9m8KyvQOSGiqrL3MX
         nOFXssOD4ZyM4CJI08sRNzvE5KMwd8ftWTtZXEsbO5SaZCDtG7EARRYN798t0cub3Dg2
         QxjsDoyM3zClMuZf4LAdqSjt4OXgQ9Yzi2PaCvPIVoJGrTzminJagTTWQ5oaq2hBdSSb
         zqqIBG6Sd9dL/Y4ZF9Q+qS6JmE/8qrx/8y2guoEjvxjYq5r50a0p1OwwyW2ThQyR2XUB
         vYShGYSr8TlnRU7xAyqp6QUyHyv98EDuesfk0PIgAooLZEn3/4yK04PzWX8MQEmM6I2+
         Obkg==
X-Gm-Message-State: AOAM530XViK9Vw7wRbhvlUIDDuNn6CL6a8v51CeaEM3d+iRD0TcXQFE5
        gsohiJmq2a4bbwhFOtzlMIbTkc1tOySW0tV4
X-Google-Smtp-Source: ABdhPJzl/5HjrqjAQCGK1rRIV5X/InNfmv/4mjaWA+B4xSMg0kQhVfZ5cUxBLeChlLpXX2OQaNseQw==
X-Received: by 2002:a17:902:7041:b029:12d:267a:d230 with SMTP id h1-20020a1709027041b029012d267ad230mr1394258plt.55.1628732444664;
        Wed, 11 Aug 2021 18:40:44 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id ca12sm745528pjb.45.2021.08.11.18.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 18:40:44 -0700 (PDT)
Subject: Re: [PATCH] block: move some macros to blkdev.h
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, colyli@suse.de,
        kent.overstreet@gmail.com, agk@redhat.com, snitzer@redhat.com
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org
References: <20210721025315.1729118-1-guoqing.jiang@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0a648cf7-69fc-d5c9-9a8d-537a644527f3@kernel.dk>
Date:   Wed, 11 Aug 2021 19:40:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210721025315.1729118-1-guoqing.jiang@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/20/21 8:53 PM, Guoqing Jiang wrote:
> From: Guoqing Jiang <jiangguoqing@kylinos.cn>
> 
> Move them (PAGE_SECTORS_SHIFT, PAGE_SECTORS and SECTOR_MASK) to the
> generic header file to remove redundancy.

Applied for 5.15, thanks.

-- 
Jens Axboe

